require 'rails_helper'

RSpec.feature "EntranceSpecs", type: :feature, js: true do
  include_context "global pages context"
  let(:starting_page) { page_object_for("entrance") }
  it_should_behave_like "any site page" # Verifies common requirements across all pages
  context "given a deleted cart referenced by the session" do
    let!(:cart) { mock_server.create_basket }
    let!(:cart_id) { cart.id }
    before(:each) do
      cart.destroy
    end
    it "should recover normally" do
      starting_page.visit
      expect(Capybara.current_session.get_rack_session[:cart_id]).not_to eql cart_id
    end


  end
end
