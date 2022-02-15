FactoryBot.define do
  factory :charge do
    amount { 100 }
    customer_email { 'email@yopmail.com' }
    customer_phone { '1234567890' }
    status { 'approved' }
  end
end
