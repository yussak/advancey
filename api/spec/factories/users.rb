FactoryBot.define do
  factory :user do
    id { 1 }
    name { 'user1@aa.com' }
    email { 'user1@aa.com' }
    uid { 'qQ3sMT8AKZZauRjeqhRarLaPFpu1' }
    profile { 'よろしくお願いします！' }
    image { nil }
    # image_url { nil }
    # image_url { 'null' }
    admin { false }
  end

  factory :other_user, class: User do
    id { 2 }
    name { 'local1@a.com' }
    email { 'local1@a.com' }
    uid { 'gl5JbR9IRKWfCBbCJi8t6r59PMl2' }
  end

  factory :admin_user, class: User do
    id { 2 }
    name { 'admin@a.com' }
    email { 'local2@a.com' }
    uid { '4FM141TYlsXszwEbw0JBJO902r32' }
    admin { true }
  end
end
