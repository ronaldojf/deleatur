require 'rails_helper'

RSpec.describe Questionnaire, :type => :model do
  it { is_expected.to be_an ActiveRecord::Base }
  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :teacher }
  it { is_expected.to validate_presence_of :classroom }
  it { is_expected.to validate_presence_of :subject }
  it { is_expected.to belong_to :teacher }
  it { is_expected.to belong_to :classroom }
  it { is_expected.to belong_to :subject }
  it { is_expected.to have_many :questions }
  it { is_expected.to have_many :answereds }
  it { is_expected.to have_many :options }
  it { is_expected.to have_many :answers }
  it { is_expected.to accept_nested_attributes_for :questions }
  it { is_expected.to define_enum_for :status }

  describe '.published' do
    before do
      2.times { create :questionnaire }
      create :questionnaire, published: true
    end

    it 'does return only published questionnaires' do
      expect(Questionnaire.published.count).to eq 1
    end
  end

  describe '.not_published' do
    before do
      2.times { create :questionnaire, published: true }
      create :questionnaire
    end

    it 'does return only not published questionnaires' do
      expect(Questionnaire.not_published.count).to eq 1
    end
  end

  describe '#update' do
    context 'when the questionnaire is published' do
      subject(:questionnaire) { create :questionnaire, published: true }

      it 'does not update the record' do
        expect(questionnaire.update(title: 'Updating...')).to_not be
      end
    end

    context 'when the questionnaire is published' do
      subject(:questionnaire) { create :questionnaire, published: false }

      it 'does update the record' do
        expect(questionnaire.update(title: 'Updating...')).to be
      end
    end
  end

  describe '#destroy' do
    context 'when the questionnaire is published' do
      subject(:questionnaire) { create :questionnaire, published: true }

      it 'does not destroy the record' do
        expect{ questionnaire.destroy }.to change { Questionnaire.count }
      end
    end

    context 'when the questionnaire is published' do
      subject(:questionnaire) { create :questionnaire, published: false }

      it 'does destroy the record' do
        expect{ questionnaire.destroy }.to_not change { Questionnaire.count }
      end
    end
  end

  describe '.by_classroom' do
    context 'when a classroom is given' do
      subject(:classroom) { create :classroom }
      before do
        2.times { create :questionnaire }
        create :questionnaire, classroom: classroom
      end

      it 'does return all questionnaires from the classroom' do
        expect(Questionnaire.by_classroom(classroom.id).count).to eq 1
      end
    end

    context 'when nothing is given' do
      before { create :questionnaire }

      it 'does return all records' do
        expect(Questionnaire.by_classroom('').count).to eq 1
      end
    end
  end

  describe '.by_subject' do
    context 'when a subject is given' do
      subject { create :subject }
      before do
        2.times { create :questionnaire }
        create :questionnaire, subject: subject
      end

      it 'does return all questionnaires from the subject' do
        expect(Questionnaire.by_subject(subject.id).count).to eq 1
      end
    end

    context 'when nothing is given' do
      before { create :questionnaire }

      it 'does return all records' do
        expect(Questionnaire.by_subject('').count).to eq 1
      end
    end
  end

  describe '.by_publication' do
    context 'when nothing is given' do
      before { create :questionnaire }

      it 'does return all records' do
        expect(Questionnaire.by_publication('').count).to eq 1
      end
    end
  end

  describe '.by_status' do
    context 'when the status pending is given' do
      subject(:questionnaire) { create :questionnaire }
      before do
        create :answered_questionnaire, status: :pending, questionnaire: questionnaire
        2.times { create :answered_questionnaire, status: :answered, questionnaire: questionnaire }
      end

      it 'does return all pending questionnaires' do
        expect(Questionnaire.joins(:answereds).by_status(:pending).count).to eq 1
      end
    end

    context 'when the status answered is given' do
      subject(:questionnaire) { create :questionnaire }
      before do
        create :answered_questionnaire, status: :answered, questionnaire: questionnaire
        2.times { create :answered_questionnaire, questionnaire: questionnaire }
      end

      it 'does return all answered questionnaires' do
        expect(Questionnaire.joins(:answereds).by_status(:answered).count).to eq 1
      end
    end

    context 'when the status fixed is given' do
      subject(:questionnaire) { create :questionnaire }
      before do
        create :answered_questionnaire, status: :fixed, questionnaire: questionnaire
        2.times { create :answered_questionnaire, questionnaire: questionnaire }
      end

      it 'does return all fixed questionnaires' do
        expect(Questionnaire.joins(:answereds).by_status('fixed').count).to eq 1
      end
    end

    context 'when nothing is given' do
      before { create :questionnaire }

      it 'does return all records' do
        expect(Questionnaire.by_status('').count).to eq 1
      end
    end
  end
end
