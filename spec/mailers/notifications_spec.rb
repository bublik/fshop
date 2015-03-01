require "rails_helper"

RSpec.describe Notifications, :type => :mailer do
  describe "contact_us" do
    let(:question){FactoryGirl.build :question }
    let(:mail) { Notifications.contact_us(question) }

    it "renders the headers" do
      expect(mail.subject).to eq("Contact Us form")
      expect(mail.to).to eq(["admin@fshop.com.ua"])
      expect(mail.from).to eq(["admin@fshop.com.ua"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("User name:")
    end
  end

end
