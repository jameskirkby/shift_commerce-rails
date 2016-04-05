require "rails_helper"
RSpec.feature "Logout Page Specs", type: :feature, js: true do
  include_context "global pages context"
  let(:starting_page) { page_object_for("logout") }
  subject { starting_page.visit }
  it_should_behave_like "any site page" # Verifies common requirements across all pages
  context "logging out" do
    let!(:registered_account) { create(:account, :registered).tap { |u| mock_server.login!(u) } }
    # after(:each) { registered_account.destroy } @TODO Will be enabled once CRUD is done in API

    let!(:users_cart) { mock_server.create_basket(customer_account_id: registered_account.id) }
    after(:each) do
      users_cart.destroy
      registered_account.destroy
    end
    it "should finish with no cart_id in the session" do
      starting_page.visit
      expect(Capybara.current_session.get_rack_session[:cart_id]).not_to eql users_cart.id
    end
  end
end