class AddCustomerEmailToOrders < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :customer_email, :string
  end
end
