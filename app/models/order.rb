# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :user
  has_one :promotion_code, dependent: :nullify
  has_one :billing_address, dependent: :destroy
  has_one :payment, dependent: :destroy
  has_many :order_items, dependent: :destroy
  accepts_nested_attributes_for :billing_address, :order_items, :payment, allow_destroy: true

  validate :promotion_code_not_used

  def total_price
    order_items.map { |item| item.price * item.amount }.sum
  end

  def final_total_price(promotion_code_id)
    total = total_price
    if promotion_code_id
      promotion_code = PromotionCode.find_by(id: promotion_code_id)
      if promotion_code
        total -= promotion_code.discount_amount.to_i
        total = 0 if total.negative? # 合計がマイナスにならないように
      end
    end
    total
  end
  

  def discount_price(promotion_code_id)
    promotion_code = PromotionCode.find(promotion_code_id)
    promotion_code = promotion_code.discount_amount.to_i if promotion_code.present?
    promotion_code
  end

  def formatted_created_at
    billing_address&.created_at&.strftime('%Y/%m/%d %H時%M分')
  end

  def add_items_from_data(order_items_data)
    order_items_data.each do |data|
      item = Item.find(data[:item_id])
      order_items.build(
        price: item.price,
        item_id: data[:item_id],
        amount: data[:amount]
      )
    end
  end

  def promotion_code_not_used
    return unless promotion_code&.used?

    errors.add(:promotion_code, I18n.t('promotion_code.used_promotion_code'))
  end
end
