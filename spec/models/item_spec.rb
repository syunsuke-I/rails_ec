# spec/models/item_spec.rb
require 'rails_helper'

RSpec.describe Item, type: :model do

  let(:item) { Item.new(name: "Test Item", price: 100, stock: 10) }

  # モデルが存在することを確認
  it "is valid with valid attributes" do
    expect(item).to be_valid
  end

  # nameバリデーションをテスト
  it "is not valid without a name" do
    item.name = nil
    expect(item).not_to be_valid
    expect(item.errors[:name]).to include("を入力してください!ß")
  end

  # priceバリデーションをテスト
  it "is not valid with a negative price" do
    item.price = -1
    expect(item).not_to be_valid
    expect(item.errors[:price]).to include("は0..の範囲に含めてください")
  end

  # stockバリデーションをテスト
  it "is not valid with a negative stock" do
    item.stock = -1
    expect(item).not_to be_valid
    expect(item.errors[:stock]).to include("は0..の範囲に含めてください")
  end

  # enough_stock? メソッドをテスト
  describe "#enough_stock?" do
    let(:item) { Item.new(stock: stock_amount) }

    context "when enough stock is available" do
      let(:stock_amount) { 10 }

      it "returns true" do
        expect(item.enough_stock?(5)).to be true
      end
    end

    context "when not enough stock is available" do
      let(:stock_amount) { 5 }

      it "returns false" do
        expect(item.enough_stock?(10)).to be false
      end
    end
  end

end
