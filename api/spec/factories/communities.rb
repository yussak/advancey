FactoryBot.define do
  factory :community do
    id { 1 }
    name { 'name1' }
    description { 'description1' }
    association :user
  end

  factory :other_community, class: Community do
    id { 2 }
    name { 'name1' }
    description { 'description1' }
    association :user, factory: :other_user
  end
end
