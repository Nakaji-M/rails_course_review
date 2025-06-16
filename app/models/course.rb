class Course < ApplicationRecord
  self.primary_key = 'id'
  
  belongs_to :department
  has_many :course_departments, dependent: :destroy
  has_many :departments, through: :course_departments
  has_many :course_teachers, dependent: :destroy
  
  validates :ocw_id, :course_number, :title_ja, :title_en, :year, :start_quarter, :end_quarter, presence: true
  
  before_create :generate_uuid
  
  private
  
  def generate_uuid
    self.id = SecureRandom.uuid if id.blank?
  end
end
