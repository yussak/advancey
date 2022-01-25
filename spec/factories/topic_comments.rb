FactoryBot.define do
  factory :topic_comment do
    topic_comment_content { "MyText" }
    user { nil }
    topic { nil }
  end
end
