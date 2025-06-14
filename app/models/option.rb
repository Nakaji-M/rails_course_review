class Option < ApplicationRecord
  belongs_to :question
  
  validates :text_ja, :text_en, :order, :filter_type, presence: true
end
