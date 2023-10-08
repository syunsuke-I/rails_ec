# frozen_string_literal: true

class CreateBillingAddressesWithOrderReference < ActiveRecord::Migration[7.0]
  def change
    create_table :billing_addresses do |t|
      t.string :first_name
      t.string :last_name
      t.string :username
      t.string :email
      t.string :country
      t.string :prefecture
      t.string :post_code
      t.string :address
      t.string :address2
      t.references :order, null: true, foreign_key: true

      t.timestamps
    end
  end
end
