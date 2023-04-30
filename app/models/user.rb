# frozen_string_literal: true

class User < ApplicationRecord
  extend FriendlyId
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_one_attached :avatar

  has_many :entries, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :likes, dependent: :destroy

  friendly_id :username, use: %i[slugged]

  validates :full_name, length: { maximum: 50 }
  validates :body, length: { maximum: 80 }
  validate :valid_username
  def valid_username
    #errors.add(:username, "is already taken") if User.exists?(username: username)
    restricted_username_list = %[admin root dashboard analytics appearance settings preferences calendar]
    errors.add(:username, 'is restricted') if restricted_username_list.include?(username)
  end

  def should_generate_new_friendly_id?
    username_changed? || slug.blank?
  end
end
