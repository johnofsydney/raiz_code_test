class CreateStocks < ActiveRecord::Migration[7.1]
  def change
    create_table :stocks do |t|
      t.string :code
      t.integer :price

      t.timestamps
    end
  end
end
