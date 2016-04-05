require 'rails_helper'
#
# This widget test tests a single instance of the customer account widget, found on the specified "starting_page".
# it does not test every instance of the widget on all pages.
RSpec.feature "Widgets::CustomerAccountWidget", type: :feature, js: true do
  include_context "global widgets context"
  let(:widget) { widget_object_for.get "customer_account" }
  let(:starting_page) { page_object_for("entrance").visit }
  let(:login_page) { page_object_for("login").attach }
  let(:logout_page) { page_object_for("logout").attach }

  # Here, we define the subject under test which is the mini basket
  # If the mini basket is not located in the header on the starting page, change to suit.
  subject do
    starting_page.visit.header.customer_account
  end

  context "starting as a guest user" do
    it "should go to the login page when requested by the user" do
      subject.login!
      expect(login_page).to be_present
    end
  end
  context "starting as a logged in user" do
    before(:each) do
      mock_server.login! registered_account
    end
    # after(:each) { registered_account.destroy } @TODO Will be enabled once CRUD is done in API
    let(:registered_account) { create(:account, :registered) }
    after(:each) { registered_account.destroy }
    it "should change its button to a logout button (for now)" do
      subject.logout!
      expect(logout_page).to be_present
    end
  end
  # @TODO Add specs for the my account link hiding and showing

end
