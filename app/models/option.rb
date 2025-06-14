class Option < ApplicationRecord
  self.primary_key = 'id'
  
  belongs_to :question
  
  validates :text_ja, :text_en, :order, :filter_type, presence: true
  
  before_create :generate_uuid
  
  private
  
  def generate_uuid
    self.id = SecureRandom.uuid if id.blank?
  end
end
