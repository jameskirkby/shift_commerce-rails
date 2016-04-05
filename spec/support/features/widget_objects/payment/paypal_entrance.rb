module MyApp
  module Test
    module ComponentObject
      class PaypalEntrance < CapybaraObjects::ComponentObject
        ctype "paypal_entrance"
        locator :css, "#content", wait: 30

        delegate :assert_order_contents_present, to: :paypal_mini_cart
        delegate :assert_shipping_address_correct, to: :paypal_review

        def paypal_mini_cart
          get_component(:paypal_mini_cart)
        end

        def paypal_login
          get_component(:paypal_login)
        end

        # Login but allow failure as it may already be logged in
        def login!(*args)
          paypal_login.login!(*args)
        rescue ::Capybara::ElementNotFound
        end

        def paypal_review
          get_component(:paypal_review)
        end
      end
    end
  end
end