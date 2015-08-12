class Classroom < ActiveRecord::Base
  has_and_belongs_to_many :subjects
  has_and_belongs_to_many :teachers

  validates :identifier, presence: true, uniqueness: { case_sensitive: false }

  scope :filter, -> (text) {
    where('identifier ILIKE :text', text: "%#{text}%") if text.present?
  }
end
