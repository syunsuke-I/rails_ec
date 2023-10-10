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
    ActiveRecord::Base.transaction do
      @user = User.create!(session_id: session.id)
      @order = build_order_with_items

      deduct_inventory_and_clear_cart
      @order.save!
      send_success_email
      flash[:info] = I18n.t('order.thank_you')
      redirect_to root_path
    end
  rescue ActiveRecord::RecordInvalid => e
    flash[:error] = e.message
    render 'carts/show'
  end

  private

  def build_order_with_items
    order = Order.new(order_params.merge(user: @user))
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

    # Orderモデルのメソッドを使って、購入明細をOrderに追加
    order.add_items_from_data(order_items_data)
  end

  def send_success_email
    OrderMailer.with(order: @order).send_order_success_email.deliver_now
  end

  def deduct_inventory_and_clear_cart
    @cart = current_or_create_cart
    @cart.cart_items.destroy_all
  end

  def order_params
    params.require(:order).permit(
      billing_address_attributes: %i[first_name last_name username email country prefecture post_code
                                     address address2],
      payment_attributes: %i[name_on_card credit_card_number expiration_date cvv]
    )
  end
end
