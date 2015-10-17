class Pontuation < ActiveRecord::Base
  MAX_POINTS = 1000.0

  belongs_to :answered_questionnaire
  belongs_to :student
  has_one :questionnaire, through: :answered_questionnaire
  has_many :answers, through: :answered_questionnaire

  before_save :set_points

  validates :answered_questionnaire, :student, presence: true
  validates :points, numericality: { greater_or_equals_than: 0, less_or_equals_than: MAX_POINTS }

  private

  def set_points
    if !self.points_changed? || !self.points.between?(0, MAX_POINTS)
      total_options = self.questionnaire.questions.sum(:question_options_count).to_d
      total_answers = self.answers.count.to_d
      right_answers = self.answers.right.count.to_d

      points_per_answer = MAX_POINTS / total_options
      points_per_answer = points_per_answer.nan? || points_per_answer.infinite? ? 0.0 : points_per_answer

      right_points = right_answers * points_per_answer
      wrong_points = (total_answers - right_answers) * points_per_answer

      self.points = right_points - wrong_points
      self.points = 0 if self.points < 0
    end
  end
end
