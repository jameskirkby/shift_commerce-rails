module MyApp
  module Test
    module ComponentObject
      class PaypalEntranceAngular < CapybaraObjects::ComponentObject
        ctype "paypal_entrance_angular"
        locator :css, "[xo-checkout]", wait: 30

        delegate :assert_order_contents_present, to: :paypal_mini_cart_angular
        delegate :assert_shipping_address_correct, to: :paypal_review_angular

        def paypal_mini_cart
          get_component(:paypal_mini_cart_angular)
        end

        def paypal_login
          get_component(:paypal_login_angular)
        end

        # Login but allow failure as it may already be logged in
        def login!(*args)
          paypal_login.login!(*args)
        rescue ::Capybara::ElementNotFound
        end

        def paypal_review
          get_component(:paypal_review_angular)
        end



      end
    end
  end
end