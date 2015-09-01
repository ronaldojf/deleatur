class Classroom < ActiveRecord::Base
  include Utils::Filtering
  has_and_belongs_to_many :subjects
  has_and_belongs_to_many :teachers

  validates :identifier, presence: true, uniqueness: { case_sensitive: false }
  filtering :identifier
end
