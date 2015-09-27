require 'rails_helper'

RSpec.describe TeacherClassroomSubject, :type => :model do
  it { is_expected.to be_an ActiveRecord::Base }
  it { is_expected.to validate_presence_of :teacher }
  it { is_expected.to validate_presence_of :teacher }
  it { is_expected.to validate_presence_of :subject }
  it { is_expected.to validate_presence_of :classroom }
  it { is_expected.to belong_to :teacher }
  it { is_expected.to belong_to :subject }
  it { is_expected.to belong_to :classroom }
end
