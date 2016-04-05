require_relative "../support/flex_admin/customer_account"
FactoryGirl.define do
  factory :account, class: "FlexCommerce::CustomerAccount" do
    sequence(:email) { |idx| "user#{idx}_#{Time.now.to_i}@testdomain.com" }
    password "agoodpassword"
    sequence(:reference) { |num| email.gsub(/@.*$/, "") }

    trait :registered do
      # At the minute there is nothing to do to ensure the account is registered
      #but in the future, if email confirmation is enabled for example
      # then we may need something in here.
    end

    trait :enhanced do
      sequence(:meta_attributes) do |idx|
        { twitter_username: { value: "twitteruser#{idx}" } }
      end
    end
  end
end
