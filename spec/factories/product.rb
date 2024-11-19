FactoryBot.define do
  factory :product do
    product_id { 3 }
    value { 817.13 }
  end

  factory :product_response, class: Product do
    id { Faker::Number.unique.number(digits: 6) }
    product_id { Faker::Number.unique.number(digits: 6) }
    value { Faker::Commerce.price.to_s }
  end
end
