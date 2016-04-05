module MyApp
  module Test
    module PageObject
      # The displaying of the order is the customers acknowledgement that all is good (i.e. their receipt)
      class Order < CapybaraObjects::PageObject
        ptype "order"
        locator :css, "body"
        attr_accessor
        def default_url
          "/order/xxx"
        end
        # Custom validate! method to identify this page correctly as the
        # root node is the body which every page has.
        def validate!
          page.assert_title(I18n.t("orders.show.page_title"), wait: 60) # Sometimes, paypal can be very slow (and this page normally comes after payment) so we wait for a while here
          super
        end

        # The cart view
        # @return [MyApp::Test::ComponentObject::Order] The order view
        def view
          get_component(:order)
        end
      end
    end
  end
end