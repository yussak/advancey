FactoryBot.define do
  factory :post do
    content { 'test1' }
    association :user
  end
end
