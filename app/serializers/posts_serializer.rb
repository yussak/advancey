class PostsSerializer < ActiveModel::Serializer
  attributes :id, :content, :user_id, :username
  belongs_to :user

  def username
    object.user.name
  end
end
