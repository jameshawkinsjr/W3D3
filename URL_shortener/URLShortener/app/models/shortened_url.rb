# == Schema Information
#
# Table name: shortened_urls
#
#  id         :bigint(8)        not null, primary key
#  long_url   :string           not null
#  short_url  :string           not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ShortenedUrl < ApplicationRecord
  validates :user_id, :long_url, presence: true
  validates :short_url, presence: true, uniqueness: true

  belongs_to :user,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :User

  has_many :visits,
    primary_key: :id,
    foreign_key: :short_url_id,
    class_name: :Visit

  has_many :unique_visitors,
    -> { distinct },
    through: :visits,
    source: :user

  def self.random_code
    random = SecureRandom.urlsafe_base64
    while ShortenedUrl.exists?(short_url: random)
      random = SecureRandom.urlsafe_base64
    end
    random
  end

  def self.create!(user, long_url)
    random = ShortenedUrl.random_code
    concat_url = "Http://www.samodonnellsfanclub.com/#{random}"
    new_url = ShortenedUrl.new(long_url: long_url, short_url: concat_url, user_id: user.id)
    new_url.save!
  end

  def num_clicks
    self.visitors.count
  end

  def num_uniques
    # self.visitors.distinct.pluck(:user_id).count
    self.unique_visitors.count
  end

  def num_recent_uniques
    self.visitors.where(created_at: (Time.now - 10.minutes)..Time.now).pluck(:user_id).count
  end
end
