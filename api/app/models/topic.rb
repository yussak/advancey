class Topic < ApplicationRecord
  include Rails.application.routes.url_helpers # url_forメソッドを使うためにRails.application.routes.url_helpersをincludeする必要があります

  belongs_to :user
  has_many :topic_comments, dependent: :destroy

  has_one_attached :image

  def image_url
    # 紐づいている画像のURLを取得する
    image.attached? ? url_for(image) : nil
  end

  # validates :title, presence: true, length: { maximum: 100 }
  # validates :content, length: { maximum: 300 } # 仮
end
