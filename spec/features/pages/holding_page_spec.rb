require 'rails_helper'

RSpec.feature "Holding Pages", type: :feature do
  let(:site_password) { "test" }

  before(:each) { ENV["SITE_PASSWORD"] = site_password }
  after(:each) { ENV["SITE_PASSWORD"] = nil }

  describe "when requesting the root path of the app" do
    before(:each) { visit "/" }

    it "should render a Service Unavailable status" do
      expect(page.status_code).to eq(503)
    end

    it "should render the holding page" do
      expect(page.body).to eq(File.read(Rails.root.join("public/holding_page.html")))
    end
  end

  describe "when requesting a non-root-path of the app" do
    before(:each) { visit "/account/login" }

    it "should render a temporary redirect to the root path" do
      expect(current_path).to eq(root_path)
    end
  end

  describe "when any path with the active site password" do
    before(:each) { visit "/?site_password=#{site_password}" }

    it "should render the path" do
      expect(page.status_code).to eq(200)
    end
  end
end
