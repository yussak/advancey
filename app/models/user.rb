class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  attr_accessor :remember_token, :reset_token

  has_many :active_relationships, class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy
  has_many :passive_relationships, class_name: 'Relationship', foreign_key: 'followed_id', dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  # いいね機能
  has_many :likes, dependent: :destroy
  has_many :like_posts, through: :likes, source: :post

  # 投稿 コメント
  has_many :comments, dependent: :destroy
  has_many :topic_comments, dependent: :destroy
  has_many :topics, dependent: :destroy

  before_save { email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
  # has_secure_password
  # validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  # validates :profile, presence: false, length: { maximum: 140 }

  # def self.digest(string)
  #   cost = if ActiveModel::SecurePassword.min_cost
  #            BCrypt::Engine::MIN_COST
  #          else
  #            BCrypt::Engine.cost
  #          end
  #   BCrypt::Password.create(string, cost: cost)
  # end

  # def self.new_token
  #   SecureRandom.urlsafe_base64
  # end

  # def remember
  #   self.remember_token = User.new_token
  #   update_attribute(:remember_digest, User.digest(remember_token))
  # end

  # def authenticated?(attribute, token)
  #   digest = send("#{attribute}_digest")
  #   return false if digest.nil?

  #   BCrypt::Password.new(digest).is_password?(token)
  # end

  def forget
    update_attribute(:remember_digest, nil)
  end

  # ユーザーのステータスフィードを返す
  def feed
    following_ids = 'SELECT followed_id FROM relationships WHERE follower_id = :user_id'
    Post.where("user_id IN (#{following_ids}) OR user_id = :user_id", user_id: id)
  end

  def follow(other_user)
    following << other_user
  end

  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # いいね機能
  # def like_this(clicked_post)
  #   likes.find_or_create_by(post: clicked_post)
  # end

  # def like?(post)
  #   like_posts.include?(post)
  # end

  def like(post)
    likes.find_or_create_by(post: post)
  end

  def like?(post)
    like_posts.include?(post)
  end

  def unlike(post)
    like_posts.delete(post)
  end

  # ゲストログイン
  def self.guest
    find_or_create_by(email: 'guest@exapmle.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = 'ゲストユーザー'
    end
  end
end
