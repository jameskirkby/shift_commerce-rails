require_relative "../support/flex_admin/order"
FactoryGirl.define do
  factory :order, class: "FlexCommerce::Order" do
    transient do
      variants []
    end
    # initialize_with do
    #   params = {data: {type: "orders"}, included: []}.deep_stringify_keys
    #   response = Struct.new(:body, :env).new(params, {url: "dummyurl"})
    #   MyApp::Test::Models::Order.parser.parse(MyApp::Test::Models::Order, response).first
    # end
  end
end