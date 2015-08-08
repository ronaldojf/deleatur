require 'rails_helper'

RSpec.describe Teacher, :type => :model do
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :gender }
  it { is_expected.to validate_presence_of :cpf }
  it { is_expected.to validate_presence_of :phone }
  it { is_expected.to validate_presence_of :birth_date }
  it { is_expected.to validate_presence_of :birth_date }
  it { is_expected.to define_enum_for :gender }
  it { is_expected.to define_enum_for :status }

  describe '.filter' do
    subject(:name) { 'Jonh' }
    subject(:cpf) { '886.975.531-21' }
    subject(:email) { 'johndoe@hotmail.com' }
    subject(:phone) { '(54) 9961-1111' }

    before do
      create :teacher, name: name, cpf: cpf, email: email, phone: phone
      create :teacher
    end

    context 'when a half of the attribute size is given' do
      it 'does return a teacher who match the name' do
        expect(Teacher.filter(name[0..(name.size / 2).to_i]).count).to eq 1
      end

      it 'does return a teacher who match the cpf' do
        expect(Teacher.filter(cpf[0..(cpf.size / 2).to_i]).count).to eq 1
      end

      it 'does return a teacher who match the email' do
        expect(Teacher.filter(email[0..(email.size / 2).to_i]).count).to eq 1
      end

      it 'does return a teacher who match the phone' do
        expect(Teacher.filter(phone[0..(phone.size / 2).to_i]).count).to eq 1
      end
    end

    context 'when all of the attribute size is given' do
      it 'does return a teacher who match the name' do
        expect(Teacher.filter(name).count).to eq 1
      end

      it 'does return a teacher who match the cpf' do
        expect(Teacher.filter(cpf).count).to eq 1
      end

      it 'does return a teacher who match the email' do
        expect(Teacher.filter(email).count).to eq 1
      end

      it 'does return a teacher who match the phone' do
        expect(Teacher.filter(phone).count).to eq 1
      end
    end

    context 'when something that will not match is given' do
      it 'does return nothing' do
        expect(Teacher.filter('2339184f9vc8nu2893').count).to eq 0
      end
    end

    context 'when nothing is given' do
      it 'does return all of the teachers' do
        expect(Teacher.filter('').count).to eq 2
      end
    end
  end

  describe '#formatted_phone' do
    subject { build :teacher, phone: '05497902135' }

    it 'does return a formatted phone' do
      expect(subject.formatted_phone).to eq '(54) 9790-2135'
    end
  end

  describe '#formatted_cpf' do
    subject { build :teacher, cpf: '01678557005' }

    it 'does return a formatted cpf' do
      expect(subject.formatted_cpf).to eq '016.785.570-05'
    end
  end

  describe '#lock' do
    context 'when the teacher is approved' do
      subject { create :teacher, status: :approved }

      it 'does lock the teacher' do
        subject.lock
        expect(subject.locked?).to be true
      end
    end

    context 'when the teacher is pending' do
      subject { create :teacher, status: :pending }

      it 'does not lock the teacher' do
        subject.lock
        expect(subject.locked?).to be false
      end
    end

    context 'when the teacher is locked' do
      subject { create :teacher, status: :locked }

      it 'does not lock the teacher again' do
        expect(subject.lock).not_to be true
      end
    end
  end

  describe '#approve' do
    context 'when the teacher is approved' do
      subject { create :teacher, status: :approved }

      it 'does not approve the teacher again' do
        expect(subject.approve).not_to be true
      end
    end

    context 'when the teacher is pending' do
      subject { create :teacher, status: :pending }

      it 'does approve the teacher' do
        subject.approve
        expect(subject.approved?).to be true
      end
    end

    context 'when the teacher is locked' do
      subject { create :teacher, status: :locked }

      it 'does approve the teacher' do
        subject.approve
        expect(subject.approved?).to be true
      end
    end
  end

  describe '#disapprove' do
    context 'when the teacher is pending' do
      subject { create :teacher, status: :pending }
      before { subject.disapprove }

      it 'does destroy the teacher' do
        expect(Teacher.count).to eq 0
      end
    end

    context 'when the teacher is approved' do
      subject { create :teacher, status: :approved }
      before { subject.disapprove }

      it 'does not destroy the teacher' do
        expect(Teacher.count).to eq 1
      end
    end

    context 'when the teacher is locked' do
      subject { create :teacher, status: :locked }
      before { subject.disapprove }

      it 'does not destroy the teacher' do
        expect(Teacher.count).to eq 1
      end
    end
  end
end
