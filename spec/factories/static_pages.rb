require_relative "../support/flex_admin/static_page"
FactoryGirl.define do
  factory :static_page, class: "FlexCommerce::StaticPage" do
    sequence(:title) { |idx| "#{Faker::Commerce.department}#{idx}" }
    slug { title.parameterize + Time.now.to_i.to_s }
    reference { slug }
    body_content 'some body content'
    body_type 'html'
    visible true

    trait :markdown do
      body_type 'markdown'
      body_content '# Hello World'
    end
    
    trait :html do
      body_type 'markdown'
    end
  end
end