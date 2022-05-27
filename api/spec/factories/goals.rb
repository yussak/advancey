FactoryBot.define do
  factory :goal do
    id { 1 }
    content { 'content1' }
    reason { 'reason1' }
    todo { 'todo1' }
    association :user
  end

  factory :other_goal, class: Goal do
    id { 2 }
    content { 'content2' }
    reason { 'reason2' }
    todo { 'todo2' }
    association :user, factory: :other_user
  end
end
