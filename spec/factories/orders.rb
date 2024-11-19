FactoryBot.define do
  factory :order_response, class: 'Order' do
    id { 877 }
    total { "817.13" }
    date { "2024-11-18" }
    association :user
  end

  factory :order, class: 'Order' do
    id { Faker::Number.unique.number(digits: 6) }
    total { Faker::Commerce.price.to_s }
    date { Faker::Date.backward(days: 14).to_s }
    association :user
  end
end