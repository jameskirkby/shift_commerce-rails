# The paypal entrance page
# Supports two different styles - the original and the angular version
# Note: The angular version was seen and these tests changed to suit, then when I went on my other machine it
# was using the non angular version and I do not understand why.
# So, rather than losing my changes, I made this entrance page so it knew about both and selected the angular
# widget objects if the page appeared to be angular (decided by the title)
module MyApp
  module Test
    module PageObject
      class PaypalEntrance < CapybaraObjects::PageObject
        ptype "paypal_entrance"
        locator :css, "body"
        def default_url
          "/itcannotbevisitedmanually"
        end
        # Custom validate! method to identify this page correctly as the
        # root node is the body which every page has.
        def validate!
          page.assert_title(/Pay with a PayPal account – PayPal|PayPal Checkout - Log In/, wait: 30)
          if page.title =~ /PayPal Checkout - Log In/
            self.is_angular_version = true
          else
            self.is_angular_version = false
          end
          super
        end

        # The paypal entrance page view
        # @return [MyApp::Test::ComponentObject::PaypalEntrance] The paypal entrance page view
        def view
          get_component(is_angular_version ? :paypal_entrance_angular : :paypal_entrance)
        end

        private

        attr_accessor :is_angular_version
      end
    end
  end
end