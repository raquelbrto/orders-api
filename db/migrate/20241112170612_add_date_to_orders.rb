class AddDateToOrders < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :date, :date
  end
end
