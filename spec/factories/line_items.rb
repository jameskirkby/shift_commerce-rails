require_relative "../support/flex_admin/line_item"
FactoryGirl.define do
  factory :line_item, class: "FlexCommerce::LineItem" do
    title { Faker::Commerce.product_name }
    unit_quantity 1
    unit_price 10.00
  end
end