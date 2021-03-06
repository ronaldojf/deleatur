require 'rails_helper'

RSpec.describe Subject, :type => :model do
  it { is_expected.to validate_presence_of :description }
  it { is_expected.to validate_uniqueness_of :description }
  it { is_expected.to have_many :classrooms_teachers }
  it { is_expected.to have_many :questionnaires }

    describe '.filter' do
    subject(:description) { 'Math' }

    before do
      create :subject, description: description
      create :subject
    end

    context 'when a half of the attribute size is given' do
      it 'does return a subject who match the description' do
        expect(Subject.filter(description[0..(description.size / 2).to_i]).count).to eq 1
      end
    end

    context 'when all of the attribute size is given' do
      it 'does return a subject who match the description' do
        expect(Subject.filter(description).count).to eq 1
      end
    end

    context 'when something that will not match is given' do
      it 'does return nothing' do
        expect(Subject.filter('2339184f9vc8nu2893').count).to eq 0
      end
    end

    context 'when nothing is given' do
      it 'does return all of the subjects' do
        expect(Subject.filter('').count).to eq 2
      end
    end
  end

  describe '.for_classroom' do
    subject(:teacher) { create :teacher }
    subject(:classroom) { create :classroom }
    before do
      teacher.classrooms_subjects << create(:teacher_classroom_subject, subject: create(:subject), classroom: classroom)
      teacher.classrooms_subjects << create(:teacher_classroom_subject, subject: create(:subject), classroom: create(:classroom))
    end

    it "does return all the subjects that a teacher have in a classroom" do
      expect(teacher.subjects.for_classroom(classroom).count).to eq 1
    end
  end

  describe '#destroy' do
    context 'when has classrooms_teachers associated' do
      let(:subject) { create(:teacher_classroom_subject).subject }

      it 'does not destroy the subject' do
        expect(subject.destroy).not_to be
        expect(Subject.count).to eq 1
      end
    end

    context 'when has questionnaires associated' do
      let(:subject) { create(:questionnaire).subject }

      it 'does not destroy the subject' do
        expect(subject.destroy).not_to be
        expect(Subject.count).to eq 1
      end
    end

    context 'when do not have any teachers_subjects, students or questionnaires associated' do
      let(:subject) { create :subject }

      it 'does destroy the subject' do
        subject.destroy
        expect(Subject.count).to eq 0
      end
    end
  end
end
