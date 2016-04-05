require 'rails_helper'
require_relative '../../lib/shift_commerce/rails/alternate_domain_constraint'

RSpec.feature "Alternate Domain Redirects", type: :feature do
  let(:primary_domain)   { "primary.domain.example.com" }
  let(:alternate_domain) { "alternate.domain.example.com" }

  let(:primary_domain_url)   { root_url(host: primary_domain) }
  let(:alternate_domain_url) { root_url(host: alternate_domain) }

  context "with no primary domain defined" do
    it "should not redirect primary domain requests" do
      visit primary_domain_url
      expect(current_url).to eq(primary_domain_url)
    end

    it "should not redirect alternate domain requests" do
      visit alternate_domain_url
      expect(current_url).to eq(alternate_domain_url)
    end
  end

  context "with a primary domain defined" do
    before(:each) { ENV["PRIMARY_DOMAIN"] = primary_domain }
    after(:each) { ENV["PRIMARY_DOMAIN"] = nil }

    it "should not redirect primary domain requests" do
      visit primary_domain_url
      expect(current_url).to eq(primary_domain_url)
    end

    it "should redirect alternate domain requests to primary domain requests" do
      visit alternate_domain_url
      expect(current_url).to eq(primary_domain_url)
    end
  end
end

RSpec.describe ShiftCommerce::Rails::AlternateDomainConstraint do
  describe "#matches?" do
    subject { described_class.new(primary_domain).matches?(request) }

    let(:primary_domain) { "primary.domain.example.com" }
    let(:alternate_domain) { "alternate.domain.example.com" }
    let(:request) { double(:request, host: host, headers: headers) }
    let(:headers) { Hash.new }

    context "given a request with a host matching the primary domain" do
      let(:host) { primary_domain }

      it "should return false" do
        expect(subject).to be false
      end
    end

    context "given a request with a Fastly host matching the primary domain" do
      let(:host) { alternate_domain }
      let(:headers) { { "HTTP_FASTLY_ORIG_HOST" => primary_domain } }

      it "should return false" do
        expect(subject).to be false
      end
    end

    context "given a request with a host NOT matching the primary domain" do
      let(:host) { alternate_domain }

      it "should return true" do
        expect(subject).to be true
      end
    end

    context "given a request with a Fastly host NOT matching the primary domain" do
      let(:host) { alternate_domain }
      let(:headers) { { "HTTP_FASTLY_ORIG_HOST" => alternate_domain } }

      it "should return true" do
        expect(subject).to be true
      end
    end
  end
end
