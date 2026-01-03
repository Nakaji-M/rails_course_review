class Answer < ApplicationRecord
  self.primary_key = 'id'
  
  belongs_to :question
  
  validates :form_token, :ocw_id, presence: true
  validates :content, presence: true, if: :required_question?
  
  before_create :generate_uuid
  
  private
  
  def generate_uuid
    self.id = SecureRandom.uuid if id.blank?
  end

  def required_question?
    question&.require
  end
end
