class AnsweredQuestionnaire < ActiveRecord::Base
  belongs_to :questionnaire
  belongs_to :student
  has_one :pontuation, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :options, through: :questionnaire
  has_many :questions, -> { order(:index) }, through: :questionnaire
  accepts_nested_attributes_for :answers, allow_destroy: true

  enum status: [:pending, :answered, :fixed]

  validates :questionnaire, :student, :status, presence: true
  validates :status, inclusion: { in: AnsweredQuestionnaire.statuses }

  scope :by_status, -> (status) {
    where(status: statuses[status]) if status.present?
  }
end
