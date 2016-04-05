require 'rails_helper'

RSpec.feature "Registration Page Specs", type: :feature, js: true do
  include_context "global pages context"
  let(:starting_page) { page_object_for("registration") }
  subject { starting_page.visit }
  it_should_behave_like "any site page" # Verifies common requirements across all pages
  context "Registration" do
    let(:registration) { subject.view }

    it "should have a registration widget" do
      expect(registration).to be_present
    end

    it "should confirm registration" do
      registration.register! attributes_for(:account).merge(name: "User Name")
      expect(page).to have_content(I18n.t("accounts.registered"))
    end

    # Note that here we do not rely on the backend to produce the errors
    # as this is often difficult to do and validation errors tend to change
    # so we are just proving that the standard way of reporting errors via the API
    # actually gets reported to the user
    context "with backend returning errors" do
      let(:errors) { { email: ["Email can't be blank"] } }
      before(:each) do
        #mock_server.stub_account_registration_errors(errors)
      end
      it "should present any registration errors" do
        registration.register! name: "User Name", email: "", password: "anyoldpassword"
        registration.assert_validation_errors(errors)
      end
    end

    it "should auto login after registration" do
      registration.register! attributes_for(:account)
      expect(page).to have_content(I18n.t("accounts.registered"))
      expect(page).to have_content(I18n.t("accounts.logged_in"))

    end


  end

end
