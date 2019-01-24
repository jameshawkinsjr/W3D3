# == Schema Information
#
# Table name: courses
#
#  id            :bigint(8)        not null, primary key
#  name          :string
#  prereq_id     :integer
#  instructor_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Course < ApplicationRecord
  has_many :enrollments,
    primary_key: :id,
    foreign_key: :course_id,
    class_name: :Enrollment

  belongs_to :course,
    primary_key: :id,
    foreign_key: :prereq_id,
    class_name: :Course

  has_many :prereqs,
    primary_key: :id,
    foreign_key: :prereq_id,
    class_name: :Course

  belongs_to :user,
    primary_key: :id,
    foreign_key: :instructor_id,
    class_name: :User

  has_many :students,
    through: :enrollments,
    source: :user
end
