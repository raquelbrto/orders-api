FactoryBot.define do
  factory :transaction_json do
    user_id { 80 }
    name { "Raquel  Kuhn" }
    orders do
      [
        {
          'order_id' => 877,
          'products' => [
            { 'product_id' => 3, 'value' => 817.13 }
          ],
          'total' => "817.13"
        }
      ]
    end
  end
end
