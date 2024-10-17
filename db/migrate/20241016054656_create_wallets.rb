class CreateWallets < ActiveRecord::Migration[7.1]
  def change
    create_table :wallets do |t|
      t.integer :balance
      t.references :owner, polymorphic: true, index: true

      t.timestamps
    end
  end
end
