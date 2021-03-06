class Answer < ActiveRecord::Base
  belongs_to :question_option
  belongs_to :answered_questionnaire
  has_one :questionnaire, through: :answered_questionnaire
  has_one :student, through: :answered_questionnaire

  validates :question_option, presence: true

  scope :right, -> { joins(:question_option).where(question_option: { right: true }) }
end
