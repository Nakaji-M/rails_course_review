class Question < ApplicationRecord
  self.primary_key = 'id'
  self.inheritance_column = nil # typeカラムの継承メカニズムを無効化
  
  belongs_to :form
  has_many :options, dependent: :destroy
  has_many :answers, dependent: :destroy
  
  validates :text_ja, :text_en, :type, :order, presence: true
  
  before_create :generate_uuid
  
  private
  
  def generate_uuid
    self.id = SecureRandom.uuid if id.blank?
  end
end
