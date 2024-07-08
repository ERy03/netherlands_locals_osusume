class User < ApplicationRecord
  has_many :recommendations
  has_many :likes
  has_many :reviews
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  validates :user_name, presence: true, uniqueness: true, length: {in: 1..20}
end
