# frozen_string_literal: true

class CreatePaymentsWithOrderReference < ActiveRecord::Migration[7.0]
  def change
    create_table :payments do |t|
      t.string :name_on_card
      t.string :credit_card_number
      t.string :expiration_date
      t.integer :cvv
      t.references :order, null: true, foreign_key: true

      t.timestamps
    end
  end
end
