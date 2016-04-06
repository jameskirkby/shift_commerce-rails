#
# @deprecated
#
# This module is being replaced (gradually)
#
require "webmock"

module ShiftCommerce
  module Rails
    module MockServerHelpers
      def mock_server_instance
        @mock_server ||= ::ShiftCommerce::Rails::MockServer.new self
      end
    end

    class MockServer
      attr_accessor :basket_helper, :customer_account_helper
      
      def initialize(parent)
        self.basket_helper = MockServerBasket.new(parent)
        self.customer_account_helper = MockServerCustomerAccount.new(parent)
      end

      delegate :create_basket, :line_items_for_cart, :cart_id, :create_promotion_for_all_orders, :delete_all_promotions, :create_coupon, to: :basket_helper
      delegate :get_address_mocks_for, :allow_address_update_for, :allow_address_create_for, :add_addresses_for, :remove_customer_accounts!, :login!, :add_basic_customer_account!, :add_enhanced_customer_account!, to: :customer_account_helper
    end

    class MockServerBasket
      include FactoryGirl::Syntax::Methods
      attr_accessor :parent

      def initialize(parent)
        self.parent = parent
      end

      def create_basket(options = {})
        cart = create(:cart, options)
        cart = FlexCommerce::Cart.find(cart.id)
        cart.update_attributes(options.except(:variants)) if [:billing_address_id, :shipping_address_id, :shipping_method_id, :email].any? {|attr| options.key?(attr)}
        session = Capybara.current_session.get_rack_session
        Capybara.current_session.set_rack_session session.merge(cart_id: cart.id)
        cart
      end
      
      def line_items_for_cart(cart_id)
        cart = FlexCommerce::Cart.find(cart_id)
        cart.line_items
      end
      
      def cart_id
        Capybara.current_session.get_rack_session["cart_id"]
      end
      
      def create_promotion_for_all_orders
        create(:promotion, :non_coupon, name: '£1.50 off all orders', promotion_type: 'AmountDiscountOnCartRule', active: true, discount_amount: 1.5, starts_at: 1.day.ago)
      end
      
      def create_coupon
        create(:promotion, :coupon, name: 'A Test Coupon', coupon_code: "coupon1", promotion_type: 'AmountDiscountOnCartRule', active: true, discount_amount: 1.5, starts_at: 1.day.ago)
      end
      
      def delete_all_promotions
        FlexCommerce::Promotion.all.each do |p|
          p.destroy rescue nil
        end
      end
    end

    class MockServerCustomerAccount
      include FactoryGirl::Syntax::Methods
      include WebMock::API
      attr_accessor :parent
      
      def initialize(parent)
        self.parent = parent
        self.addresses = {}
      end
      def method_missing(method, *args, &block)
        return super unless parent.respond_to?(method)
        parent.send(method, *args, &block)
      end
      def remove_customer_accounts!
        MyApp::Test::Models::CustomerAccount.delete_all
      end

      def login!(account)
        session = Capybara.current_session.get_rack_session
        Capybara.current_session.set_rack_session session.merge(account_id: account.id)
      end

      def add_basic_customer_account!
        create(:account)
      end

      def add_enhanced_customer_account!
        create(:account, :enhanced)
      end

      def add_addresses_for(account, options = {})
        create_list(:address, options[:quantity] || 1, {customer_account_id: account.id}.merge(options.except(:quantity)))
      end

      def allow_address_create_for(account, options = {})
        # {"errors"=>[{"detail"=>"Email can't be blank", "title"=>"Email can't be blank", "source"=>{"pointer"=>"email"}}, {"detail"=>"Password can't be blank", "title"=>"Password can't be blank", "source"=>{"pointer"=>"password"}}]}
        Rails.logger.warn("WARNING - allowing adding of addresses to a customer account is currently done by stubbing - not the real server as it is not implemented yet")
        response_body = options.key?(:errors) ? errors_for(options[:errors]).to_json  : build(:address_resource).to_json

        stub_request(:post, "#{api_root}/customer_accounts/#{account.id}/addresses.json_api").with(headers: api_default_request_headers).to_return body: response_body, headers: api_default_response_headers, status: 201
        self
      end

      def allow_address_update_for(account, options = {})
        re = %r(#{flex_account}/v1/customer_accounts/#{account.id}/addresses/([^\/]*)\.json_api)
        stub_request(:patch, re).with(headers: api_default_request_headers).to_return do |request, a, b, c|
          id = request.uri.to_s.match(re)[1]
          response_body = options.key?(:errors) ? errors_for(options[:errors]).to_json : { data: addresses[account.id].data.detect { |r| r.id == id } }.to_json
          { body: response_body, headers: api_default_response_headers }
        end

      end

      def get_address_mocks_for(account, options = {})
        account.addresses
      end

      private

      attr_accessor :addresses

      def errors_for(ar_errors)
        op = []
        ar_errors.each_pair do |attr, errors|
          errors.each do |error|
            op << { detail: error, title: error, source: { pointer: attr } }
          end
        end
        { errors: op }
      end

    end
    
    class MockServerStaticPage
      include FactoryGirl::Syntax::Methods
      
      def create_static_page(options = {})
        create(:static_page)
      end

    end
  end
end

RSpec.configure do |config|
  config.include ShiftCommerce::Rails::MockServerHelpers
end
