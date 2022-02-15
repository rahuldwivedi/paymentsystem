FactoryBot.define do
  factory :user do
    name { "admin" }
    email {"admin@yopmail.com"}
    amount { 1200 }
    password_confirmation {"password"}
    password {"password"}
    type {"Admin"}
  end
end
