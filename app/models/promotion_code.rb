# frozen_string_literal: true

class PromotionCode < ApplicationRecord
  belongs_to :order, optional: true

  # プロモーションコードを使用するメソッド
  def use!
    update(used: true)
  end
end
