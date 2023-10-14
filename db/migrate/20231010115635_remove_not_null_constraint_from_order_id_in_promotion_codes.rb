# frozen_string_literal: true

class RemoveNotNullConstraintFromOrderIdInPromotionCodes < ActiveRecord::Migration[7.0]
  def change
    change_column_null :promotion_codes, :order_id, true
  end
end
