require 'rails_helper'

RSpec.feature "Reset Password Request Page Specs", type: :feature, js: true do
  include_context "global pages context"
  let(:starting_page) { page_object_for("reset_password_request") }
  let(:reset_page) { page_object_for("reset_password") }
  let(:login_page) { page_object_for("login") }
  let(:emailed_link) do
    parse_email_for_link(email, "Change my password")
  end
  let(:email) do
    email = open_email(account.email)
  end
  subject { starting_page.visit.view }

  it_should_behave_like "any site page" # Verifies common requirements across all pages
  context "successful password reset" do
    let!(:account) { create(:account) }
    after(:each) { account.destroy }
    it "should send an email with token to rest password", requires_email: true do
      subject.request_password_reset!(email: account.email)
      expect(page).to have_content(I18n.t("accounts.reset_password_requested"))
      visit emailed_link
      reset_page.attach
      reset_page.view.password_reset!(password: "mynewpassword")
      expect(page).to have_content(I18n.t("accounts.password_changed"))
      expect(login_page).to be_present
    end
  end
  context "failing password resets" do
    let!(:account) { create(:account) }
    after(:each) { account.destroy }
    context "not found" do
      it "should inform the user that it has gone wrong" do
        subject.request_password_reset!(email: account.email + "wrong")
        expect(page).to have_content(I18n.t("accounts.reset_password_requested"))

      end
    end
    context "invalid token" do
      it "should inform the user that it has gone wrong"
    end
  end
end
