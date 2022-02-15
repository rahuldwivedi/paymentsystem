FactoryBot.define do
  factory :transaction do
    amount { 100 }
    user
    customer_email { 'email@yopmail.com' }
  end
end
