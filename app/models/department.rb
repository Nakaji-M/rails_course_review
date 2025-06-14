class Department < ApplicationRecord
  self.primary_key = 'id'
  
  has_many :courses, dependent: :destroy
  has_many :course_departments, dependent: :destroy
  
  validates :name, presence: true
end
