require 'rails_helper'

RSpec.describe Student, :type => :model do
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :gender }
  it { is_expected.to validate_presence_of :birth_date }
  it { is_expected.to validate_presence_of :classroom }
  it { is_expected.to validate_uniqueness_of :cpf }
  it { is_expected.to define_enum_for :gender }
  it { is_expected.to define_enum_for :status }
  it { is_expected.to have_many :pontuations }
  it { is_expected.to have_many :teachers }
  it { is_expected.to have_many :answered_questionnaires }
  it { is_expected.to have_many :questionnaires }
  it { is_expected.to belong_to :classroom }

  describe '.filter' do
    subject(:name) { 'Jonh' }
    subject(:cpf) { '886.975.531-21' }
    subject(:email) { 'johndoe@hotmail.com' }
    subject(:phone) { '(54) 9961-1111' }

    before do
      create :student, name: name, cpf: cpf, email: email, phone: phone
      create :student
    end

    context 'when a half of the attribute size is given' do
      it 'does return a student who match the name' do
        expect(Student.filter(name[0..(name.size / 2).to_i]).count).to eq 1
      end

      it 'does return a student who match the cpf' do
        expect(Student.filter(cpf[0..(cpf.size / 2).to_i]).count).to eq 1
      end

      it 'does return a student who match the email' do
        expect(Student.filter(email[0..(email.size / 2).to_i]).count).to eq 1
      end

      it 'does return a student who match the phone' do
        expect(Student.filter(phone[0..(phone.size / 2).to_i]).count).to eq 1
      end
    end

    context 'when all of the attribute size is given' do
      it 'does return a student who match the name' do
        expect(Student.filter(name).count).to eq 1
      end

      it 'does return a student who match the cpf' do
        expect(Student.filter(cpf).count).to eq 1
      end

      it 'does return a student who match the email' do
        expect(Student.filter(email).count).to eq 1
      end

      it 'does return a student who match the phone' do
        expect(Student.filter(phone).count).to eq 1
      end
    end

    context 'when something that will not match is given' do
      it 'does return nothing' do
        expect(Student.filter('2339184f9vc8nu2893').count).to eq 0
      end
    end

    context 'when nothing is given' do
      it 'does return all of the students' do
        expect(Student.filter('').count).to eq 2
      end
    end
  end

  describe '.in_classroom' do
    subject(:classroom) { create :classroom }
    before do
      create :student, classroom: classroom
      create :student
    end

    context 'when a classroom is given' do
      it 'does return the students into the classroom' do
        expect(Student.in_classroom(classroom).count).to eq 1
      end
    end

    context 'when a classroom is not given' do
      it 'does return all the students' do
        expect(Student.in_classroom(nil).count).to eq 2
      end
    end
  end

  describe '#formatted_phone' do
    subject { build :student, phone: '5497902135' }

    it 'does return a formatted phone' do
      expect(subject.formatted_phone).to eq '(54) 9790-2135'
    end
  end

  describe '#formatted_cpf' do
    subject { build :student, cpf: '01678557005' }

    it 'does return a formatted cpf' do
      expect(subject.formatted_cpf).to eq '016.785.570-05'
    end
  end

  describe '#lock' do
    context 'when the student have status normal' do
      subject { create :student, status: :normal }

      it 'does lock the student' do
        subject.lock
        expect(subject.locked?).to be true
      end
    end

    context 'when the student is locked' do
      subject { create :student, status: :locked }

      it 'does not lock the student again' do
        expect(subject.lock).not_to be true
      end
    end
  end

  describe '#unlock' do
    context 'when the student have status normal' do
      subject { create :student, status: :normal }

      it 'does not set status normal to the student again' do
        expect(subject.unlock).not_to be true
      end
    end

    context 'when the student is locked' do
      subject { create :student, status: :locked }

      it 'does unlock the student' do
        subject.unlock
        expect(subject.normal?).to be true
      end
    end
  end

  describe '.by_status' do
    context "when a status 'locked' is given" do
      before do
        create :student, status: :locked
        2.times { create :student, status: :normal }
      end

      it 'does return only the locked records' do
        expect(Student.by_status('locked').count).to eq 1
      end
    end

    context "when a status 'normal' is given" do
      before do
        create :student, status: :normal
        2.times { create :student, status: :locked }
      end

      it 'does return only the normal records' do
        expect(Student.by_status('normal').count).to eq 1
      end
    end
  end

  describe '.by_gender' do
    context "when a gender 'male' is given" do
      before do
        create :student, gender: :male
        2.times { create :student, gender: :female }
      end

      it 'does return only the male people' do
        expect(Student.by_gender('male').count).to eq 1
      end
    end

    context "when a gender 'female' is given" do
      before do
        create :student, gender: :female
        2.times { create :student, gender: :male }
      end

      it 'does return only the female people' do
        expect(Student.by_gender('female').count).to eq 1
      end
    end
  end

  describe '#active_for_authentication?' do
    context 'when is blocked' do
      subject(:student) { build :student, status: :locked }

      it 'does not be active' do
        expect(student.active_for_authentication?).not_to be
      end
    end

    context 'when is normal' do
      subject(:student) { build :student, status: :normal }

      it 'does be active' do
        expect(student.active_for_authentication?).to be
      end
    end
  end

  describe '#student_questionnaires' do
    context 'when the student do not have an answered questionnaire' do
      let(:classroom) { create :classroom }
      let(:student) { create :student, classroom: classroom }
      let!(:questionnaire) { create :questionnaire, published: true, classroom: classroom }
      let!(:student_questionnaire) { student.student_questionnaires.first }

      it 'does return the fields of the questionnaire but with status and points with defaults' do
        expect(student_questionnaire.id).to eq questionnaire.id
        expect(student_questionnaire.title).to eq questionnaire.title
        expect(student_questionnaire.subject_id).to eq questionnaire.subject_id
        expect(student_questionnaire.teacher_id).to eq questionnaire.teacher_id
        expect(student_questionnaire.updated_at.to_s).to eq questionnaire.updated_at.to_s
        expect(student_questionnaire.points).to eq 0
      end
    end

    context 'when the student has an answered questionnaire' do
      let(:classroom) { create :classroom }
      let(:student) { create :student, classroom: classroom }
      let!(:questionnaire) { create :questionnaire, published: true, classroom: classroom }
      let!(:question) { create :question, questionnaire: questionnaire }
      let!(:answered) do
        create :answered_questionnaire,
          questionnaire: questionnaire,
          student: student,
          status: 1,
          answers: [create(:answer, question_option: create(:question_option, question: question, right: true))]
      end
      let!(:pontuation) { create(:pontuation, student: student, answered_questionnaire: answered) }
      let!(:student_questionnaire) { student.student_questionnaires.first }

      it 'does the fields of the questionnaire plus the answered questionnaire' do
        expect(student_questionnaire.id).to eq questionnaire.id
        expect(student_questionnaire.title).to eq questionnaire.title
        expect(student_questionnaire.subject_id).to eq questionnaire.subject_id
        expect(student_questionnaire.teacher_id).to eq questionnaire.teacher_id
        expect(student_questionnaire.updated_at.to_s).to eq questionnaire.updated_at.to_s
        expect(student_questionnaire.status).to eq 'answered'
        expect(student_questionnaire.points).to eq 9.99
      end
    end
  end

  describe '.top_ranking' do
    let!(:classroom) { create :classroom }
    let!(:questionnaire) { create :questionnaire, classroom: classroom }
    let!(:question) { create :question, questionnaire: questionnaire }
    let!(:option) { create :question_option, question: question }
    let!(:student) { create :student, classroom: classroom }
    let!(:answered) { student.answered_questionnaires.create(questionnaire_id: questionnaire.id, status: :answered) }

    it 'does return student id' do
      ranking = Student.top_ranking(1).first
      expect(ranking.id).to eq student.id
    end

    it "does return the classroom's identifier" do
      ranking = Student.top_ranking(1).first
      expect(ranking.classroom_identifier).to eq classroom.identifier
    end

    context 'when already has points' do
      let!(:pontuation) { create :pontuation, answered_questionnaire: answered, student: student }

      it 'does return the total_points' do
        ranking = Student.top_ranking(1).first
        expect(ranking.total_points).to eq 9.99
      end
    end

    context 'when do not have any points' do
      it 'does return the total_points as 0' do
        ranking = Student.top_ranking(1).first
        expect(ranking.total_points).to eq 0.0
      end
    end
  end

  describe '#get_ranking' do
    let!(:classroom) { create :classroom }
    let!(:questionnaire) { create :questionnaire, classroom: classroom }
    let!(:question) { create :question, questionnaire: questionnaire }
    let!(:option) { create :question_option, question: question }
    let!(:student1) { create :student, classroom: classroom }
    let!(:student2) { create :student, classroom: classroom }
    let!(:answered1) { student1.answered_questionnaires.create(questionnaire_id: questionnaire.id, status: :answered) }
    let!(:answered2) { student2.answered_questionnaires.create(questionnaire_id: questionnaire.id, status: :answered) }
    let!(:pontuation1) { create :pontuation, answered_questionnaire: answered1, student: student1 }

    it 'does return the ranking_position' do
      ranking = student2.get_ranking
      expect(ranking.ranking_position).to eq 2
    end

    it 'does return the classroom_identifier' do
      ranking = student2.get_ranking
      expect(ranking.classroom_identifier).to eq classroom.identifier
    end

    context 'when already has points' do
      it 'does return the total_points' do
        ranking = student1.get_ranking
        expect(ranking.total_points).to eq 9.99
      end
    end

    context 'when do not have any points' do
      it 'does return the total_points' do
        ranking = student2.get_ranking
        expect(ranking.total_points).to eq 0.0
      end
    end
  end
end
