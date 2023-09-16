class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.string "name" , presence: true
      t.string "img_address"
      t.text "description"
      t.integer "price" , presence: true , numericality: true
      t.integer "stock" , presence: true , numericality: true
      t.timestamps
    end
  end
end
