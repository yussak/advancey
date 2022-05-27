FactoryBot.define do
  factory :news do
    id { 1 }
    content { 'news1' }
    association :user
  end

  factory :other_news, class: News do
    id { 2 }
    content { 'news2' }
    association :user, factory: :other_user
  end
end
