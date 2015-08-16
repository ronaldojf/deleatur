require 'rails_helper'

RSpec.describe Student, :type => :model do
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :gender }
  it { is_expected.to validate_presence_of :birth_date }
  it { is_expected.to validate_presence_of :classroom }
  it { is_expected.to validate_uniqueness_of :cpf }
  it { is_expected.to define_enum_for :gender }
  it { is_expected.to define_enum_for :status }
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
end
