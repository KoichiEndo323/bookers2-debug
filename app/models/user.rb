class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,:recoverable, :rememberable, :validatable

  has_many :books
  has_many :favorites,dependent: :destroy
  has_many :book_comments,dependent: :destroy
  has_many :user_rooms
  has_many :rooms, through: :user_rooms, foreign_key:"follower_id"
  has_many :messages, dependent: :destroy
  has_many :entries, dependent: :destroy
  has_many :read_counts, dependent: :destroy

  #フォローする側
  has_many :relationships, class_name:'Relationship',foreign_key: :following_id, dependent: :destroy
  #フォローしている全員のデータをとってくる。中間テーブルを介して、followerテーブルから
  has_many :followings,through: :relationships,source: :follower

  #フォローされる側
  has_many :reverse_of_relationships,class_name:'Relationship',foreign_key: :follower_id, dependent: :destroy
  #フォローされている全員のデータをとってくる。中間テーブルを介して、follwingから
  has_many :followers,through: :reverse_of_relationships,source: :following

  has_one_attached :profile_image

  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: {  maximum: 50 }

  def is_followed_by?(user)
    reverse_of_relationships.find_by(following_id: user.id).present?
  end

#検索方法の分岐
  def self.looks(search, word)
    if search == "perfect"
      @user = User.where("name LIKE ?", "#{word}")
    elsif search == "forward"
      @user = User.where("name LIKE ?", "#{word}%")
    elsif search == "backward"
      @user = User.where("name LIKE ?", "%#{word}")
    elsif search == "partial"
      @user = User.where("name LIKE ?", "%#{word}%")
    else
      @user = User.all
    end
  end
end
