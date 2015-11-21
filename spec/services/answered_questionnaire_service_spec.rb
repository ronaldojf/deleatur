require 'rails_helper'

RSpec.describe AnsweredQuestionnaireService, :type => :service do
  describe '#update' do
    context 'when none parameters is given' do
      let(:service) { AnsweredQuestionnaireService.new(build(:answered_questionnaire)) }

      it 'does not raise an error' do
        expect { service.update({}) }.to_not raise_error
        expect(service.update({})).to be_nil
      end
    end
  end

  describe '#update!' do
    context 'when is pending' do
      let!(:classroom) { create :classroom }
      let!(:questionnaire) { create :questionnaire, classroom: classroom }
      let!(:question) { create :question, questionnaire: questionnaire }
      let!(:option) { create :question_option, question: question }
      let!(:student) { create :student, classroom: classroom }
      let(:answered) { student.answered_questionnaires.build(questionnaire_id: questionnaire.id) }
      let(:service) { AnsweredQuestionnaireService.new(answered) }
      let(:params) { { answers_attributes: [{chosed: 'on', question_option_id: option.id}] } }

      it 'does receive the status answered' do
        service.update!(params)
        expect(answered.reload.answered?).to be
      end

      it 'does create a pontuation' do
        service.update!(params)
        expect(answered.reload.pontuation.persisted?).to be
      end
    end

    context 'when is answered' do
      let!(:classroom) { create :classroom }
      let!(:questionnaire) { create :questionnaire, classroom: classroom }
      let!(:question) { create :question, questionnaire: questionnaire }
      let!(:option) { create :question_option, question: question }
      let!(:student) { create :student, classroom: classroom }
      let!(:answered) { student.answered_questionnaires.create(questionnaire_id: questionnaire.id, status: :answered) }
      let!(:pontuation) { create :pontuation, answered_questionnaire: answered, student: student }
      let(:service) { AnsweredQuestionnaireService.new(answered) }
      let(:params) { { answers_attributes: [{chosed: 'on', question_option_id: option.id}] } }

      it 'does not create or update a new pontuation' do
        service.update!(params)
        expect(answered.pontuation.reload.id).to eq pontuation.id
        expect(answered.pontuation.reload.points).to eq pontuation.points
      end

      it 'does update the questionnaire' do
        service.update!(params)
        service.update!({
          answers_attributes: [
            {id: answered.answers.first.id, chosed: 'off', question_option_id: option.id},
            {chosed: 'on', question_option_id: option.id},
            {chosed: 'off', question_option_id: option.id},
            {chosed: 'on', question_option_id: option.id}
          ]
        })

        expect(answered.answers.reload.count).to eq 2
      end
    end

    context 'when is fixed' do
      let!(:classroom) { create :classroom }
      let!(:questionnaire) { create :questionnaire, classroom: classroom }
      let!(:question) { create :question, questionnaire: questionnaire }
      let!(:option) { create :question_option, question: question }
      let!(:student) { create :student, classroom: classroom }
      let!(:answered) { student.answered_questionnaires.create(questionnaire_id: questionnaire.id, status: :answered) }
      let!(:pontuation) { create :pontuation, answered_questionnaire: answered, student: student }
      let(:service) { AnsweredQuestionnaireService.new(answered) }
      let(:params) { { answers_attributes: [{chosed: 'on', question_option_id: option.id}] * 2 } }

      it 'does not create or update a new pontuation' do
        service.update!({ answers_attributes: [] })
        expect(answered.pontuation.reload.id).to eq pontuation.id
        expect(answered.pontuation.reload.points).to eq pontuation.points
      end

      it 'does update the questionnaire' do
        service.update!(params)
        service.update!({
          answers_attributes: [
            {chosed: 'off', question_option_id: option.id},
            {id: answered.answers.first.id, chosed: 'off', question_option_id: option.id},
            {id: answered.answers.last.id, chosed: 'on', question_option_id: option.id},
            {chosed: 'off', question_option_id: option.id}
          ]
        })

        expect(answered.answers.reload.count).to eq 1
      end
    end

    context 'when none parameters is given' do
      let(:service) { AnsweredQuestionnaireService.new(build(:answered_questionnaire)) }

      it 'does raise an error' do
        expect { service.update!({}) }.to raise_error
      end
    end
  end

  describe '#wrong_indexes_of' do
    let!(:questionnaire) { create :questionnaire }
    let!(:answered) { create :answered_questionnaire, questionnaire: questionnaire }
    before do
      questionnaire.questions << [
        create(:question, index: 0, options: [
          create(:question_option, right: false),
          create(:question_option, right: false)
        ]),
        create(:question, index: 1, options: [
          create(:question_option, right: false,  answers: [create(:answer, answered_questionnaire: answered)]),
          create(:question_option, right: false)
        ]),
        create(:question, index: 2, options: [
          create(:question_option, right: false),
          create(:question_option, right: true,   answers: [create(:answer, answered_questionnaire: answered)]),
          create(:question_option, right: false)
        ]),
        create(:question, index: 3, options: [
          create(:question_option, right: false,  answers: [create(:answer, answered_questionnaire: answered)]),
          create(:question_option, right: true,   answers: [create(:answer, answered_questionnaire: answered)]),
          create(:question_option, right: false,  answers: [create(:answer, answered_questionnaire: answered)])
        ]),
        create(:question, index: 4, options: [
          create(:question_option, right: true,   answers: [create(:answer, answered_questionnaire: answered)]),
          create(:question_option, right: false),
          create(:question_option, right: true,   answers: [create(:answer, answered_questionnaire: answered)])
        ]),
        create(:question, index: 5, options: [
          create(:question_option, right: true,   answers: [create(:answer, answered_questionnaire: answered)]),
          create(:question_option, right: false,  answers: [create(:answer, answered_questionnaire: answered)]),
          create(:question_option, right: false),
          create(:question_option, right: true)
        ]),
        create(:question, index: 6, options: [
          create(:question_option, right: true),
          create(:question_option, right: false,  answers: [create(:answer, answered_questionnaire: answered)])
        ])
      ]
    end

    it 'does return the only the indexes of the questions that are answered wrong' do
      service = AnsweredQuestionnaireService.new(answered)

      wrong_indexes = service.wrong_indexes_of(questionnaire)

      expect(wrong_indexes).to eq [1,3,5,6]
    end
  end
end
