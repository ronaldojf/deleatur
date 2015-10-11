require 'rails_helper'

RSpec.describe QuestionOption, :type => :model do
  it { is_expected.to be_an ActiveRecord::Base }
  it { is_expected.to validate_presence_of :description }
  it { is_expected.to belong_to :question }
  it { is_expected.to have_one :answer }

  describe '.right' do
    before do
      2.times { create :question_option }
      create :question_option, right: true
    end

    it 'does return only the right options' do
      expect(QuestionOption.right.count).to eq 1
    end
  end
end
