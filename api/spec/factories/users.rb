FactoryBot.define do
  factory :user do
    id { 1 }
    name { 'user1@aa.com' }
    email { 'user1@aa.com' }
    uid { 'qQ3sMT8AKZZauRjeqhRarLaPFpu1' }
  end

  factory :other_user, class: User do
    id { 2 }
    name { 'local1@a.com' }
    email { 'local1@a.com' }
    uid { 'gl5JbR9IRKWfCBbCJi8t6r59PMl2' }
  end
end
