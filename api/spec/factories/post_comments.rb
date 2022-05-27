FactoryBot.define do
  factory :post_comment do
    id { 1 }
    content { 'test1' }
    association :user
    association :post
  end

  # factory :other_post_comment, class: PostComment do
  #   id { 2 }
  #   content { 'test2' }
  #   association :user, factory: :other_user
  # end
end
