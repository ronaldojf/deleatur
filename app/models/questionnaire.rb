class Questionnaire < ActiveRecord::Base
  include Utils::Filtering

  ALLOWED_TAGS = %w(p div span br hr ol ul li blockquote h1 h2 h3 h4 h5 table tbody thead tr th td)
  ALLOWED_ATTRIBUTES = %w(style class)

  belongs_to :teacher
  belongs_to :classroom
  belongs_to :subject
  has_many :questions, -> { order(:index) }, dependent: :destroy
  has_many :answereds, class_name: 'AnsweredQuestionnaire', foreign_key: :questionnaire_id, dependent: :destroy
  has_many :options, through: :questions
  has_many :answers, through: :answereds
  accepts_nested_attributes_for :questions, allow_destroy: true

  enum status: AnsweredQuestionnaire.statuses

  validates :title, :teacher, :classroom, :subject, presence: true
  validates :questions, presence: true, if: [:persisted?, :published?]

  filtering :title
  scope :published, -> { by_publication(true) }
  scope :not_published, -> { by_publication(false) }

  scope :by_publication, -> (published) { where(published: published) if published.to_s.present? }

  scope :by_classroom, -> (classroom) {
    joins(:classroom)
    .where(classroom: { id: classroom.try(:id) || classroom }) if classroom.present?
  }

  scope :by_subject, -> (subject) {
    joins(:subject)
    .where(subject: { id: subject.try(:id) || subject }) if subject.present?
  }

  scope :by_status, -> (status) {
    where('COALESCE(answered_questionnaires.status, 0) = ?', statuses[status]) if status.present?
  }

  def destroy
    super unless self.published?
  end

  def update(params)
    super(params) unless self.published?
  end
end
