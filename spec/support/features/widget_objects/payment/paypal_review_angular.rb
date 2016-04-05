module MyApp
  module Test
    module ComponentObject
      class PaypalReviewAngular < CapybaraObjects::ComponentObject
        ctype "paypal_review_angular"
        locator :css, "[xo-review-page]", wait: 30

        def wait_until_ready
          # Wait for the shipping method node to go disabled then re enabled - suggesting it is ready
          shipping_method_node(disabled: true, wait: 10)
          shipping_method_node(disabled: false, wait: 10)
        end
        def assert_shipping_address_correct(cart:)
          errors = []
          cart.shipping_address.tap do |expected|
            [:first_name, :middle_names, :last_name, :address_line_1, :city, :state, :postcode, :country].each do |field|
              expected_text = expected.send(field)
              expected_text = ISO3166::Country.new(expected_text).name if field == :country
              expected_text.upcase! if field == :postcode
              begin
                shipping_address_node(text: expected_text)
              rescue Capybara::ExpectationNotMet => ex
                errors << "Field #{field} expectation not met.  #{ex.message}"
              end
            end
          end
          raise Capybara::ExpectationNotMet, "Expected delivery address to be correct but there were errors (below)\n#{errors.join("\n")}" unless errors.empty?
        end

        def submit!
          continue_button_node.click
        end

        def select_shipping_method(sm)
          shipping_method_option_node(sm).select_option
          shipping_method_node(disabled: true, wait: 10)  # Wait for this to go disabled
          shipping_method_node(disabled: false, wait: 10)  # Wait for this to be come re enabled (its a bit slow)
        end

        private

        def shipping_method_option_node(sm)
          shipping_method_node.find(:css, "option", text: sm.label)
        end

        def shipping_method_node(options = {})
          scoped_find(:select, "shipping_method", options)
        end

        def shipping_address_node(options = {})
          scoped_find(:css, ".addressDisplay", {match: :first}.merge(options))
        end

        def continue_button_node
          scoped_find(:button, "Continue", match: :first, disabled: false)
        end
      end
    end
  end
end
