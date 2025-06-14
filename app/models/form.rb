class Form < ApplicationRecord
  self.primary_key = 'id'
  
  has_many :questions, dependent: :destroy
  
  validates :year, presence: true, uniqueness: true
  
  before_create :generate_uuid
  
  private
  
  def generate_uuid
    self.id = SecureRandom.uuid if id.blank?
  end
end
