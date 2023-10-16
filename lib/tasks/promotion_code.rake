# frozen_string_literal: true

namespace :promotion_code do
  desc 'Generate promotion codes'
  task generate: :environment do
    10.times do
      code = SecureRandom.alphanumeric(7)
      # わかりやすく50円刻みにする
      discount_amount = (rand(2..20) * 50)
      PromotionCode.create!(code:, discount_amount:)
    end
  end
end
