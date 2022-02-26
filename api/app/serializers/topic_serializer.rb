class TopicSerializer < ActiveModel::Serializer
  attributes :id, :title, :content, :solve_status, :user_id, :username, :created_at
  belongs_to :user

  def username
    object.user.name
  end
end
