class Teacher < ApplicationRecord
  self.primary_key = 'id'
  
  has_many :course_teachers, dependent: :destroy
  has_many :courses, through: :course_teachers
  
  validates :name, presence: true
  
  before_create :generate_uuid
  
  private
  
  def generate_uuid
    self.id = SecureRandom.uuid if id.blank?
  end
end
