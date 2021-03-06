require "spec_helper"

describe UserMailer do
  describe "signup_confirmation" do
    let(:user) { FactoryGirl.create(:user) }
    let(:mail) { UserMailer.signup_confirmation(user) }

    it "renders the headers" do
      mail.subject.should eq("Sign Up Confirmation")
      mail.to.should eq([user.email])
      mail.from.should eq(["chris.barthol@gmail.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
