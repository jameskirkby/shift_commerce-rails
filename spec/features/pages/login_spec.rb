require 'rails_helper'

RSpec.feature "Login Page Specs", type: :feature, js: true do
  include_context "global pages context"
  let(:starting_page) { page_object_for("login") }
  subject { starting_page.visit }
  it_should_behave_like "any site page" # Verifies common requirements across all pages
  context "Logging in" do
    let!(:registered_account) { create(:account, :registered) }
    let(:login_view) { subject.view }
    after(:each) { registered_account.destroy rescue nil }
    it "should have a registration widget" do
      expect(login_view).to be_present
    end

    it "should confirm successful login" do
      login_view.login!email: registered_account.email, password: registered_account.password
      expect(page).to have_content(I18n.t("accounts.logged_in"))
      expect(page.get_rack_session.with_indifferent_access).to include account_id: registered_account.id
    end

    context "with a guest cart" do
      let!(:products) { FlexCommerce::Product.where(filter: {"in_stock" => {"eq" => true}}).paginate(per_page: 10, page: 1).all }
      let(:guest_variants) { products[0..2].map { |p| FlexCommerce::Product.find("slug:#{p.slug}").variants.first } }
      let(:customer_variants) { products[5..7].map { |p| FlexCommerce::Product.find("slug:#{p.slug}").variants.first } }

      let!(:guest_cart) { mock_server.create_basket variants: guest_variants }
      let!(:customer_cart) { create(:cart, variants: customer_variants, customer_account_id: registered_account.id) }
      # Fetches the merged cart
      let(:merged_cart) { FlexCommerce::Cart.find(customer_cart.id) }

      it "should call the backend service to merge carts on login" do
        login_view.login!email: registered_account.email, password: registered_account.password
        expect(page).to have_content(I18n.t("accounts.logged_in"))
        expect(merged_cart.line_items_count).to eql(guest_variants.length + customer_variants.length)
      end
    end

    context "with backend returning errors" do
      let(:errors) { { email: [I18n.t("account_sessions.create.incorrect_email_or_password")] } }
      it "should present any registration errors" do
        login_view.login! email: "anemailwhichisdefinitely@wrong.com", password: "areallywrongpassword"
        login_view.assert_validation_errors(errors)
      end
    end
  end
end
