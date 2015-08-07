class Subject < ActiveRecord::Base
  has_and_belongs_to_many :classrooms

  validates :description, presence: true, uniqueness: true

  scope :filter, -> (text) {
    where('description ILIKE :text', text: "%#{text}%") if text.present?
  }
end
