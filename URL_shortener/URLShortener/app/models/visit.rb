# == Schema Information
#
# Table name: visits
#
#  id           :bigint(8)        not null, primary key
#  user_id      :integer          not null
#  short_url_id :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Visit < ApplicationRecord
  validates :user_id, :short_url_id, presence: true

  belongs_to :user,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :User

  belongs_to :short_url,
    primary_key: :id,
    foreign_key: :short_url_id,
    class_name: :ShortenedUrl

  def self.record_visit!(user, short_url)
    new_visit = Visit.new(user_id: user.id, short_url_id: short_url.id)
    new_visit.save
  end
end
