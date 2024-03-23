# frozen_string_literal: true

class ModifyPromotionCodesAndOrders < ActiveRecord::Migration[7.0]
  def change
    # ordersにpromotion_code_idを追加
    add_reference :orders, :promotion_code, foreign_key: true
  end
end
