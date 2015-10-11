class QuestionOption < ActiveRecord::Base
  belongs_to :question, counter_cache: true
  has_one :answer

  validates :description, presence: true

  scope :right, -> { where(right: true) }
end
