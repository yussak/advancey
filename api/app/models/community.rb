class Community < ApplicationRecord
  has_many :belongings, dependent: :destroy
  has_many :users, through: :belongings

  has_many :mesasges
end
