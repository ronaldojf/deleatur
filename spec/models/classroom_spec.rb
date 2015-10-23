require 'rails_helper'

RSpec.describe Classroom, :type => :model do
  it { is_expected.to validate_presence_of :identifier }
  it { is_expected.to validate_uniqueness_of :identifier }
  it { is_expected.to have_many :teachers_subjects }
  it { is_expected.to have_many :students }
  it { is_expected.to have_many :questionnaires }

  describe '.filter' do
    subject(:identifier) { '301-A' }

    before do
      create :classroom, identifier: identifier
      create :classroom
    end

    context 'when a half of the attribute size is given' do
      it 'does return a classroom who match the identifier' do
        expect(Classroom.filter(identifier[0..(identifier.size / 2).to_i]).count).to eq 1
      end
    end

    context 'when all of the attribute size is given' do
      it 'does return a classroom who match the identifier' do
        expect(Classroom.filter(identifier).count).to eq 1
      end
    end

    context 'when something that will not match is given' do
      it 'does return nothing' do
        expect(Classroom.filter('2339184f9vc8nu2893').count).to eq 0
      end
    end

    context 'when nothing is given' do
      it 'does return all of the classrooms' do
        expect(Classroom.filter('').count).to eq 2
      end
    end
  end

  describe '#destroy' do
    context 'when has teachers_subjects associated' do
      let(:classroom) { create(:teacher_classroom_subject).classroom }

      it 'does not destroy the classroom' do
        expect(classroom.destroy).not_to be
        expect(Classroom.count).to eq 1
      end
    end

    context 'when has students associated' do
      let(:classroom) { create(:student).classroom }

      it 'does not destroy the classroom' do
        expect(classroom.destroy).not_to be
        expect(Classroom.count).to eq 1
      end
    end

    context 'when has questionnaires associated' do
      let(:classroom) { create(:questionnaire).classroom }

      it 'does not destroy the classroom' do
        expect(classroom.destroy).not_to be
        expect(Classroom.count).to eq 1
      end
    end

    context 'when do not have any teachers_subjects, students or questionnaires associated' do
      let(:classroom) { create :classroom }

      it 'does destroy the classroom' do
        classroom.destroy
        expect(Classroom.count).to eq 0
      end
    end
  end
end
