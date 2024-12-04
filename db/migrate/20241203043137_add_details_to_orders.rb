class AddDetailsToOrders < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :subtotal, :decimal
    add_column :orders, :taxes, :decimal
  end
end
