FactoryGirl.define do
  factory :address, class: "FlexCommerce::Address" do
    sequence(:first_name)   { |n| "#{Faker::Name.first_name}#{n}" }
    sequence(:last_name)    { |n| "#{Faker::Name.last_name}#{n}" }
    sequence(:middle_names) { |n| "#{Faker::Name.first_name}#{n}" }
    sequence(:address_line_1) { |idx| "Address#{idx} line 1" }
    sequence(:address_line_2) { |idx| "Address#{idx} line 2" }
    sequence(:address_line_3) { |idx| "Address#{idx} line 3" }
    sequence(:city) { |idx| "Address#{idx} city" }
    sequence(:state) { |idx| "Address#{idx} State" }
    sequence(:country) { |idx| "GB" }
    sequence(:postcode) { |idx| "Address#{idx} postcode" }
    sequence(:preferred_billing) { |idx| false }
    preferred_shipping false

  end
end