module MyApp
  module Test
    module ComponentObject
      class Checkout < CapybaraObjects::ComponentObject
        ctype "checkout"
        locator :css, "[data-behavior='checkout_view']"
        delegate :assert_billing_address_equals, to: :billing_address
        delegate :assert_shipping_address_equals, to: :shipping_address

        # The billing address widget
        # @return [MyApp::Test::ComponentObject::CheckoutBillingAddress]
        def billing_address
          get_component(:checkout_billing_address)
        end

        # The shipping address widget
        # @return [MyApp::Test::ComponentObject::CheckoutShippingAddress]
        def shipping_address
          get_component(:checkout_shipping_address)
        end

        # Submits the order
        def submit!
          submit_button_node.click
        end

        def assert_shipping_methods(methods)
          methods.each do |value|
            shipping_method_option_for(value)
          end
        end

        def select_shipping_method(reference)
          shipping_method_option_for(reference).select_option
        end

        def email_address=(value)
          email_address_node.set(value)
        end

        def assert_out_of_stock!
          stock_warnings_node.present?
        end

        def assert_submit_button_disabled!
          raise Capybara::ExpectationNotMet.new "Submit button should be disabled but it is not" unless submit_button_node[:disabled]
        end

        private

        def shipping_method_option_for(reference)
          shipping_method_node.find(:css, "option[value='#{reference}']")
        end

        def shipping_method_node
          scoped_find(:css, "*[name='cart[shipping_method_id]']")
        end

        def email_address_node
          scoped_find(:css, "*[name='cart[email]']")
        end

        def submit_button_node
          scoped_find(:css, '[data-behavior="submit"]')
        end

        def stock_warnings_node
          scoped_find(:css, "[data-behavior=\"stock_warnings\"]")
        end
      end
    end
  end
end