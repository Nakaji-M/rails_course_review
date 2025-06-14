class Answer < ApplicationRecord
  belongs_to :course
  belongs_to :question
  
  validates :form_token, :content, presence: true
end
