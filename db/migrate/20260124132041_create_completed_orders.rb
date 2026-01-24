class CreateCompletedOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :completed_orders do |t|
      t.integer :number
      t.string :color
      t.integer :tyholt
      t.integer :pina
      t.integer :mojito

      t.timestamps
    end
  end
end
