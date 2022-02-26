class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :profile
  has_many :posts
end
