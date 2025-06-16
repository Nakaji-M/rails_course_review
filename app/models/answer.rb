class Answer < ApplicationRecord
  self.primary_key = 'id'
  
  belongs_to :question
  
  validates :form_token, :content, :ocw_id, presence: true
  
  before_create :generate_uuid
  
  private
  
  def generate_uuid
    self.id = SecureRandom.uuid if id.blank?
  end
end
