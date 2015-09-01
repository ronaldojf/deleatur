class Subject < ActiveRecord::Base
  include Utils::Filtering
  has_and_belongs_to_many :classrooms
  has_and_belongs_to_many :teachers

  validates :description, presence: true, uniqueness: { case_sensitive: false }
  filtering :description
end
