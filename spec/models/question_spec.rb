require 'rails_helper'

RSpec.describe Question, :type => :model do
  it { is_expected.to be_an ActiveRecord::Base }
  it { is_expected.to validate_presence_of :description }
  it { is_expected.to belong_to :questionnaire }
  it { is_expected.to have_many :options }
  it { is_expected.to accept_nested_attributes_for :options }
end
