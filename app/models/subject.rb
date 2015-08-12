class Subject < ActiveRecord::Base
  has_and_belongs_to_many :classrooms
  has_and_belongs_to_many :teachers

  validates :description, presence: true, uniqueness: { case_sensitive: false }

  scope :filter, -> (text) {
    where('description ILIKE :text', text: "%#{text}%") if text.present?
  }
end
