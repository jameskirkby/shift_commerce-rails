require 'rails_helper'

RSpec.feature "My Profile Page Specs", type: :feature, js: true do
  include_context "global pages context"
  let(:starting_page) { page_object_for("my_profile") }
  subject { starting_page.visit }
  it_should_behave_like "any site page" # Verifies common requirements across all pages
  let(:view) { subject.view }
  context "with basic profile setup" do
    let!(:customer_account) do
      mock_server.add_basic_customer_account!.tap do |a|
        mock_server.login!(a)
      end
    end
    after(:each) { customer_account.destroy }

    it "should have a view" do
      expect(view).to be_present
    end

    it "should show email address" do
      expect(view.email_node.value).to eql(customer_account.email)
    end

    it "should allow the user to change email address" do
      view.update_email! attributes_for(:account)[:email]
      expect(page).to have_content(I18n.t("accounts.edit.updated"))
    end
  end

  context "with enhanced profile setup with extra metadata" do
    let!(:customer_account) do
      mock_server.add_enhanced_customer_account!.tap do |a|
        mock_server.login!(a)
      end
    end
    # after(:each) { customer_account.destroy } @TODO Will be enabled once CRUD is done in API

    it "should show the twitter account" do
      expect(view.twitter_username_node.value).to eql(customer_account.twitter_username)
    end

    it "should allow the user to change the twitter username" do
      view.update_twitter_username! "mynewtwitterusername"
      expect(page).to have_content(I18n.t("accounts.edit.updated"))
      expect(view.twitter_username_node.value).to eql("mynewtwitterusername")
    end

    it "should keep the twitter username when the user updates the email address" do
      view.update_email! attributes_for(:account)[:email]
      expect(page).to have_content(I18n.t("accounts.edit.updated"))
      expect(view.twitter_username_node.value).to eql(customer_account.twitter_username)
    end
  end

end
