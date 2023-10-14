# frozen_string_literal: true

class OrdersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @orders = Order.includes(:billing_address)
  end

  def show
    @order = Order.includes(:order_items, :billing_address, :payment).find(params[:id])
  end

  def create
    params[:redeem_button] ? redeem : create_order
  end

  private

  def send_success_email
    OrderMailer.with(order: @order).send_order_success_email.deliver_now
  end

  def deduct_inventory_and_clear_cart
    @cart = current_or_create_cart
    @cart.cart_items.destroy_all
  end

  def redeem
    # プロモーション適応処理
    code = redeem_params[:promotion_code_code]
    promotion = PromotionCode.find_by(code:)
    if promotion && !promotion.used?
      session[:discount_amount] = promotion.discount_amount
      session[:promotion_code] = code
      redirect_to cart_path, notice: I18n.t('promotion_code.is_applied')
    else
      redirect_to cart_path, alert: I18n.t('promotion_code.is_invalid')
    end
  end

  def create_order
    return unless ensure_cart_is_not_empty

    ActiveRecord::Base.transaction do
      @user = User.create!(session_id: session.id)
      @order = build_order_with_items
      @order.save!
      deduct_inventory_and_clear_cart
      update_promotion_code_status
      send_success_email
      flash[:info] = I18n.t('order.thank_you')
      clear_promotion_from_session
      redirect_to root_path
    rescue ActiveRecord::RecordInvalid
      set_show_variables
      render 'carts/show'
    end
  end

  def ensure_cart_is_not_empty
    return true if params.dig(:order, :order_items_attributes).present?

    flash[:error] = I18n.t('order.is_empty')
    redirect_to cart_path
    false
  end

  def build_order_with_items
    order = Order.new(order_params.merge(user: @user))
    if session[:promotion_code].present?
      promotion = PromotionCode.find_by(code: session[:promotion_code])
      order.promotion_code_id = promotion.id
    end
    add_items_to_order(order)
    order
  end

  def add_items_to_order(order)
    order_items_data = params[:order][:order_items_attributes]&.values&.map do |order_item_data|
      {
        item_id: order_item_data[:item_id].to_i,
        amount: order_item_data[:amount].to_i
      }
    end
    order.add_items_from_data(order_items_data)
  end

  def update_promotion_code_status
    code = redeem_params[:promotion_code_code]
    return if code.blank?

    promotion = PromotionCode.find_by(code:)
    promotion.update(used: true)
  end

  def clear_promotion_from_session
    session.delete(:discount_amount)
    session.delete(:promotion_code)
  end

  def set_show_variables
    @cart = current_or_create_cart
    @order ||= Order.new
    @order.build_billing_address
    @order.build_payment
    @order.order_items.new
  end

  def redeem_params
    params.require(:order).permit(
      :promotion_code_code
    )
  end

  def order_params
    params.require(:order).permit(
      billing_address_attributes: %i[first_name last_name username email country prefecture post_code
                                     address address2],
      payment_attributes: %i[name_on_card credit_card_number expiration_date cvv]
    )
  end
end
