class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.string :status
      t.datetime :placed_at
      t.datetime :delivered_at
      t.integer :amount
      t.integer :tax
      t.string :street_address
      t.string :city
      t.string :state
      t.string :country
      t.integer :pincode

      t.timestamps
    end
  end
end
