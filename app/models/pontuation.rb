class Pontuation < ActiveRecord::Base
  TOTAL_POINTS = 1000.0
  EXTRA_POINTS = 100.0

  belongs_to :answered_questionnaire
  belongs_to :student
  has_one :questionnaire, through: :answered_questionnaire
  has_many :answers, through: :answered_questionnaire

  before_save :set_points

  validates :answered_questionnaire, :student, presence: true
  validates :points, numericality: { greater_or_equals_than: 0 }

  def generate_extra_points
    if !self.has_extra_points?
      answers_count = self.answers.count
      return false if (answers_count != self.answers.right.count || answers_count != self.questionnaire.options.right.count)


      self.points += EXTRA_POINTS
      self.has_extra_points = true
      self.save
    end
  end

  private

  def set_points
    if !self.has_extra_points? && (!self.points_changed? || !self.points.between?(0, TOTAL_POINTS))
      total_options = self.questionnaire.questions.sum(:question_options_count).to_d
      total_answers = self.answers.count.to_d
      right_answers = self.answers.right.count.to_d

      points_per_answer = TOTAL_POINTS / total_options
      points_per_answer = points_per_answer.nan? || points_per_answer.infinite? ? 0.0 : points_per_answer

      right_points = right_answers * points_per_answer
      wrong_points = (total_answers - right_answers) * points_per_answer

      self.points = right_points - wrong_points
      self.points = 0 if self.points < 0
    end
  end
end
