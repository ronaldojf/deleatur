require 'rails_helper'

RSpec.describe Pontuation, :type => :model do
  it { is_expected.to be_an ActiveRecord::Base }
  it { is_expected.to validate_presence_of :answered_questionnaire }
  it { is_expected.to validate_presence_of :student }
  it { is_expected.to validate_numericality_of :points }
  it { is_expected.to belong_to :answered_questionnaire }
  it { is_expected.to belong_to :student }
  it { is_expected.to have_one :questionnaire }
  it { is_expected.to have_many :answers }

  describe '#set_points' do
    context 'when a questionnaire have 10 options' do
      let!(:classroom) { create :classroom }
      let!(:questionnaire) { create :questionnaire, classroom: classroom }
      let!(:question1) { create :question, questionnaire: questionnaire }
      let!(:question2) { create :question, questionnaire: questionnaire }
      let!(:student) { create :student, classroom: classroom }
      before do
        5.times { create(:question_option, right: true, question: question1) }
        5.times { create(:question_option, right: false, question: question2) }
      end

      it 'does set 0 points if there are 0 wrong and 0 right' do
        answered = student.answered_questionnaires.create(questionnaire_id: questionnaire.id)
        pontuation = create :pontuation, student: student, answered_questionnaire: answered, points: -1

        expect(pontuation.reload.points).to eq 0
      end

      it 'does set 0 points if there are 4 wrong and 3 right' do
        answers = question1.options.first(3).collect { |option| build :answer, question_option_id: option.id }
        answers += question2.options.first(4).collect { |option| build :answer, question_option_id: option.id }
        answered = student.answered_questionnaires.create(questionnaire_id: questionnaire.id, answers: answers)
        pontuation = create :pontuation, student: student, answered_questionnaire: answered, points: -1

        expect(pontuation.reload.points).to eq 0
      end

      it 'does set 0 points if there are 5 wrong and 5 right' do
        answers = question1.options.collect { |option| build :answer, question_option_id: option.id }
        answers += question2.options.collect { |option| build :answer, question_option_id: option.id }
        answered = student.answered_questionnaires.create(questionnaire_id: questionnaire.id, answers: answers)
        pontuation = create :pontuation, student: student, answered_questionnaire: answered, points: -1

        expect(pontuation.reload.points).to eq 0
      end

      it 'does set 100 points if there are 2 wrong and 3 right' do
        answers = question1.options.first(3).collect { |option| build :answer, question_option_id: option.id }
        answers += question2.options.first(2).collect { |option| build :answer, question_option_id: option.id }
        answered = student.answered_questionnaires.create(questionnaire_id: questionnaire.id, answers: answers)
        pontuation = create :pontuation, student: student, answered_questionnaire: answered, points: -1

        expect(pontuation.reload.points).to eq 100.to_d
      end

      it 'does set 300 points if there are 1 wrong and 4 right' do
        answers = question1.options.first(4).collect { |option| build :answer, question_option_id: option.id }
        answers += question2.options.first(1).collect { |option| build :answer, question_option_id: option.id }
        answered = student.answered_questionnaires.create(questionnaire_id: questionnaire.id, answers: answers)
        pontuation = create :pontuation, student: student, answered_questionnaire: answered, points: -1

        expect(pontuation.reload.points).to eq 300.to_d
      end
    end
  end
end
