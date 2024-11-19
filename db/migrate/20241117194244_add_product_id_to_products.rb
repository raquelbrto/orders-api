class AddProductIdToProducts < ActiveRecord::Migration[7.2]
  def change
    add_column :products, :product_id, :integer
  end
end
