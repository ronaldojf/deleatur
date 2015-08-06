class Subject < ActiveRecord::Base
  validates :description, presence: true, uniqueness: true

  scope :filter, -> (text) {
    where('description ILIKE :text', text: "%#{text}%") if text.present?
  }
end
