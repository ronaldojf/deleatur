require 'rails_helper'

RSpec.describe AnsweredQuestionnaire, :type => :model do
  it { is_expected.to be_an ActiveRecord::Base }
  it { is_expected.to validate_presence_of :questionnaire }
  it { is_expected.to validate_presence_of :student }
  it { is_expected.to validate_presence_of :status }
  it { is_expected.to have_many :answers }
  it { is_expected.to have_many :options }
  it { is_expected.to have_many :questions }
  it { is_expected.to belong_to :questionnaire }
  it { is_expected.to belong_to :student }

  describe '.by_status' do
    context "when searched for pending answered questionnaires" do
      before do
        create :answered_questionnaire
        2.times { create :answered_questionnaire, status: :answered }
      end

      it "does return only the pending answered questionnaires" do
        expect(AnsweredQuestionnaire.by_status('pending').count).to eq 1
      end
    end

    context "when searched for answered answered questionnaires" do
      before do
        create :answered_questionnaire, status: :answered
        2.times { create :answered_questionnaire }
      end

      it "does return only the answered answered questionnaires" do
        expect(AnsweredQuestionnaire.by_status(:answered).count).to eq 1
      end
    end

    context "when searched for fixed answered questionnaires" do
      before do
        create :answered_questionnaire, status: :fixed
        2.times { create :answered_questionnaire }
      end

      it "does return only the fixed answered questionnaires" do
        expect(AnsweredQuestionnaire.by_status(:fixed).count).to eq 1
      end
    end

    context "when nothing is given" do
      before { create :answered_questionnaire }

      it "does return all answered questionnaires" do
        expect(AnsweredQuestionnaire.by_status('').count).to eq 1
      end
    end
  end
end
