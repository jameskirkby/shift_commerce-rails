require_relative "../support/flex_admin/cart"
FactoryGirl.define do
  factory :cart, class: "FlexCommerce::Cart" do
    transient do
      variants []
    end
    after(:create) do |instance, evaluator|
      next if evaluator.variants.empty?
      evaluator.variants.each do |variant_record|
        create(:line_item, item_id: variant_record.id, item_type: "Variant", container_id: instance.id, title: variant_record.title, unit_price: variant_record.price, unit_quantity: 1)
      end
    end
  end
end