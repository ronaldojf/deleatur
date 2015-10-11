require 'rails_helper'

RSpec.describe Answer, :type => :model do
  it { is_expected.to be_an ActiveRecord::Base }
  it { is_expected.to validate_presence_of :question_option }
  it { is_expected.to validate_presence_of :answered_questionnaire }
  it { is_expected.to belong_to :question_option }
  it { is_expected.to belong_to :answered_questionnaire }
  it { is_expected.to have_one :questionnaire }
  it { is_expected.to have_one :student }
end
