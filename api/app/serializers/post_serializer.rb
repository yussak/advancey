class PostSerializer < ActiveModel::Serializer
  attributes :id, :content, :user_id, :username, :created_at
  belongs_to :user

  def username
    object.user.name
  end
end
