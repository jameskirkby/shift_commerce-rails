require 'rails_helper'

RSpec.feature "URL Rewrites", type: :feature do
  before(:context) { FlexCommerce::Redirect.all.map(&:destroy) }

  describe "when requesting a random page" do
    context "with a redirect" do
      let!(:redirect_instance) { FlexCommerce::Redirect.create name: "A not so random path to root", source_type: :exact, source_path: "/a-not-so-random-path", destination_type: :exact, destination_path: "/" }
      after(:each) { redirect_instance.destroy }
      before(:each) { visit "/a-not-so-random-path" }

      it "should render a Found status" do
        expect(page.status_code).to eq(200)
      end

      it "should redirect to the given location" do
        expect(current_path).to eq("/")
      end
    end

    context "with no redirect" do
      before(:each) { visit "/a-random-path" }

      it "should render a Not Found status" do
        expect(page.status_code).to eq(404)
      end
    end
  end

  describe "when requesting a product page" do
    context "with a redirect" do
      let!(:redirect_instance) { FlexCommerce::Redirect.create name: "A product path to root", source_type: :exact, source_path: "/products/abc", destination_type: :exact, destination_path: "/" }
      after(:each) { redirect_instance.destroy }

      before(:each) { visit "/products/abc" }

      it "should render a Found status" do
        expect(page.status_code).to eq(200)
      end

      it "should redirect to the given location" do
        expect(current_path).to eq("/")
      end
    end

    context "with no redirect" do
      before(:each) { visit "/products/def" }

      it "should render a Not Found status" do
        expect(page.status_code).to eq(404)
      end
    end
  end
end
