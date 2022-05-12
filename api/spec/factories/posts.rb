FactoryBot.define do
  factory :post do
    id { 1 }
    content { 'test1' }
    association :user
  end

  factory :other_post, class: Post do
    id { 2 }
    content { 'test2' }
    association :user, factory: :other_user
  end
end
