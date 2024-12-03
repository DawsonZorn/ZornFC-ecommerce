class AddProvinceToCustomers < ActiveRecord::Migration[7.2]
  def change
    add_column :customers, :province, :string
  end
end
