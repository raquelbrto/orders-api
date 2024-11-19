class Order < ApplicationRecord
  belongs_to :user
  
  has_many :order_transactions, class_name: "Transaction"
  has_many :products, through: :order_transactions

end
