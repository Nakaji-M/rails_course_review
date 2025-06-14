class Answer < ApplicationRecord
  self.primary_key = 'id'
  
  belongs_to :course
  belongs_to :question
  
  validates :form_token, :content, presence: true
  
  before_create :generate_uuid
  
  private
  
  def generate_uuid
    self.id = SecureRandom.uuid if id.blank?
  end
end
