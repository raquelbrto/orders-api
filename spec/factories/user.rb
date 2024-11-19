FactoryBot.define do
  factory :user_response, class: User do
    id { 80 }
    name { "Raquel  Kuhn" }
  end

  factory :user, class: User do
    id { Faker::Number.unique.number(digits: 6) }
    name { Faker::Name.name }
  end
end