class Product < ApplicationRecord
  has_many :product_transactions, class_name: "Transaction", foreign_key: "product_id"
  has_many :orders, through: :product_transactions
end
