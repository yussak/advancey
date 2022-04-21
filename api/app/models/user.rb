class User < ApplicationRecord
  include Rails.application.routes.url_helpers

  has_one_attached :image
  # 色んな所に同じものあるので共通化したい
  def image_url
    url_for(image) if image.attached?
  end

  has_many :posts, dependent: :destroy
  # attr_accessor :remember_token, :reset_token

  has_many :goals, dependent: :destroy
  has_many :goal_comments, dependent: :destroy

  # フォロー
  has_many :active_relationships, class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy
  has_many :passive_relationships, class_name: 'Relationship', foreign_key: 'followed_id', dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  # コミュニティ
  has_many :belongings, dependent: :destroy
  has_many :communities, through: :belongings

  has_many :messages, dependent: :destroy

  # # 投稿コメント
  # has_many :comments, dependent: :destroy
  # has_many :topic_comments, dependent: :destroy
  has_many :topics, dependent: :destroy

  # before_save { email.downcase! }
  # validates :name, presence: true, length: { maximum: 50 }
  # VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  # validates :email, presence: true, length: { maximum: 255 },
  #                   format: { with: VALID_EMAIL_REGEX },
  #                   uniqueness: true
  # has_secure_password
  # validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  # validates :profile, presence: false, length: { maximum: 140 }

  # # ユーザーのステータスフィードを返す
  # def feed
  #   following_ids = 'SELECT followed_id FROM relationships WHERE follower_id = :user_id'
  #   Post.where("user_id IN (#{following_ids}) OR user_id = :user_id", user_id: id)
  # end

  def follow(other_user)
    following << other_user
  end

  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # def following?(other_user)
  #   following.include?(other_user)
  # end
end
