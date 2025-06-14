class CourseTeacher < ApplicationRecord
  self.primary_key = nil
  
  belongs_to :course
  
  validates :nameJa, :nameEn, presence: true
end
