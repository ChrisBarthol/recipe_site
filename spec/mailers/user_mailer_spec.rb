require "spec_helper"

describe UserMailer do
  describe "signup_confirmation" do
    let(:mail) { UserMailer.signup_confirmation }

    it "renders the headers" do
      mail.subject.should eq("Signup confirmation")
      mail.to.should eq(user.email)
      mail.from.should eq(["chris.barthol@gmail.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Sign up")
    end
  end

end
