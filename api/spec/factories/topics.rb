FactoryBot.define do
  factory :topic do
    id { 1 }
    title { 'title1' }
    content { 'content1' }
    association :user
  end

  factory :other_topic, class: Topic do
    id { 2 }
    title { 'title2' }
    content { 'content2' }
    association :user, factory: :other_user
  end
end
