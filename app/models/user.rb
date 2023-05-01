class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,:recoverable, :rememberable, :validatable

  has_many :books
  has_many :favorites,dependent: :destroy
  has_many :book_comments,dependent: :destroy

  #フォローする側
  has_many :relationships,foreign_key: :following_id
  #フォローしている全員のデータをとってくる。中間テーブルを介して、followerテーブルから
  has_many :followings,through: :relationships,source: :follower

  #フォローされる側
  has_many :reverse_of_relationships,foreign_key: :follower_id
  #フォローされている全員のデータをとってくる。中間テーブルを介して、follwingから
  has_many :followers,through: :reverse_of_relationships,source: :following

  has_one_attached :profile_image

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: {  maximum: 50 }

  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end

end
