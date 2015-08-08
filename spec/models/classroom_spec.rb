require 'rails_helper'

RSpec.describe Classroom, :type => :model do
  it { is_expected.to validate_presence_of :identifier }
  it { is_expected.to validate_uniqueness_of :identifier }
  it { is_expected.to have_and_belong_to_many :subjects }

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
end
