require 'rails_helper'

RSpec.describe User::Base, :type => :unit do
  let! :ExampleUser do
    class ExampleUser
      include User::Base
    end
  end

  describe '#user_type' do
    subject(:user) { ExampleUser.new }

    it 'does return the name of the class as a symbol' do
      expect(user.user_type).to eq :example_user
    end
  end

  describe '#administrator?' do
    subject(:user) { ExampleUser.new }
    subject(:administrator) { Administrator.new }
    let! :Administrator do
      class Administrator
        include User::Base
      end
    end

    it 'does return true if it is an administrator' do
      expect(administrator.administrator?).to be
    end

    it 'does return false if it is not an administrator' do
      expect(user.administrator?).not_to be
    end
  end

  describe '#teacher?' do
    subject(:user) { ExampleUser.new }
    subject(:teacher) { Teacher.new }
    let! :Teacher do
      class Teacher
        include User::Base
      end
    end

    it 'does return true if it is a teacher' do
      expect(teacher.teacher?).to be
    end

    it 'does return false if it is not a teacher' do
      expect(user.teacher?).not_to be
    end
  end

  describe '#student?' do
    subject(:user) { ExampleUser.new }
    subject(:student) { Student.new }
    let! :Student do
      class Student
        include User::Base
      end
    end

    it 'does return true if it is a student' do
      expect(student.student?).to be
    end

    it 'does return false if it is not a student' do
      expect(user.student?).not_to be
    end
  end
end