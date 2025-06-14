class CourseDepartment < ApplicationRecord
  self.primary_key = nil
  
  belongs_to :course
  belongs_to :department
end
