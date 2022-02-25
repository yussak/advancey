class TopicSerializer < ActiveModel::Serializer
  attributes :id, :title, :user_id, :username, :created_at
  belongs_to :user

  def username
    object.user.name
  end
end
