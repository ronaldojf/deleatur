class Question < ActiveRecord::Base
  belongs_to :questionnaire
  has_many :options, -> { order(:index) }, class_name: 'QuestionOption', foreign_key: :question_id, dependent: :destroy
  accepts_nested_attributes_for :options, allow_destroy: true

  validates :description, presence: true
end
