require 'rails_helper'

RSpec.describe Administrator, :type => :model do
  it { should validate_presence_of :name }

    describe ".filter" do
    subject(:name) { "Jonh" }
    subject(:email) { "johndoe@hotmail.com" }

    before do
      create :administrator, name: name, email: email
      create :administrator
    end

    context "when a half of the attribute size is given" do
      it "does return a administrator who match the name" do
        expect(Administrator.filter(name[0..(name.size / 2).to_i]).count).to eq 1
      end

      it "does return a administrator who match the email" do
        expect(Administrator.filter(email[0..(email.size / 2).to_i]).count).to eq 1
      end
    end

    context "when all of the attribute size is given" do
      it "does return a administrator who match the name" do
        expect(Administrator.filter(name).count).to eq 1
      end

      it "does return a administrator who match the email" do
        expect(Administrator.filter(email).count).to eq 1
      end
    end

    context "when something that will not match is given" do
      it "does return nothing" do
        expect(Administrator.filter("2339184f9vc8nu2893").count).to eq 0
      end
    end

    context "when nothing is given" do
      it "does return all of the administrators" do
        expect(Administrator.filter("").count).to eq 2
      end
    end
  end

  describe "#destroy" do
    it "does not destroy if is a main administrator" do
      administrator = create :administrator, main: true
      administrator.destroy
      expect(Administrator.count).to eq 1
    end

    it "does destroy if is not a main administrator" do
      administrator = create :administrator
      administrator.destroy
      expect(Administrator.count).to eq 0
    end
  end
end
