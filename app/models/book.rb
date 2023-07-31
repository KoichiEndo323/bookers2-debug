class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites,dependent: :destroy
  has_many :book_comments,dependent: :destroy
  has_many :read_counts, dependent: :destroy
  
  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

#一週間の間でいいねの多い順にソート
  def favorites_within_past_week
    favorites.where(created_at: 1.week.ago..Time.zone.now).count
  end

#投稿数の集計日時
  scope :created_today, -> { where(created_at: Time.zone.now.all_day) } # 今日
  scope :created_yesterday, -> { where(created_at: 1.day.ago.all_day) } # 前日
  scope :created_this_week, -> { where(created_at: 6.day.ago.beginning_of_day..Time.zone.now.end_of_day) } #今週
  scope :created_last_week, -> { where(created_at: 2.week.ago.beginning_of_day..1.week.ago.end_of_day) } # 前週
#日数を指定できる定義
  (0..6).each do |days|
  scope "created_#{days}day_ago".to_sym, -> { where(created_at: days.days.ago.all_day) }
end

  
#検索方法の分岐
    def self.looks(search, word)
      if search == "perfect"
        @book = Book.where("title LIKE ?", "#{word}")
      elsif search == "forward"
        @book = Book.where("title LIKE ?", "#{word}%")
      elsif search == "backward"
        @book = Book.where("title LIKE ?", "%#{word}")
      elsif search == "partial"
        @book = Book.where("title LIKE ?", "%#{word}%")
      else
        @book = Book.all
      end
    end
end
