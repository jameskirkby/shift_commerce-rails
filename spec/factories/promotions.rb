require_relative "../support/flex_admin/promotion"
FactoryGirl.define do
  factory :promotion, class: "FlexCommerce::Promotion" do
    name { Faker::Commerce.product_name }
    promotion_type "AmountDiscountOnCartRule"
    active true
    discount_amount 1.5
    trait :coupon do
      coupon_type "simple"

    end
    trait :non_coupon do

    end
  end
end