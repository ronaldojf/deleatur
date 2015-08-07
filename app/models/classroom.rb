class Classroom < ActiveRecord::Base
  has_and_belongs_to_many :subjects

  validates :identifier, presence: true, uniqueness: true

  scope :filter, -> (text) {
    where('identifier ILIKE :text', text: "%#{text}%") if text.present?
  }
end
