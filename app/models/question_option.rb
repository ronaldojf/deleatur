class QuestionOption < ActiveRecord::Base
  belongs_to :question, counter_cache: true
  has_many :answers

  validates :description, presence: true

  scope :right, -> { where(right: true) }
end
