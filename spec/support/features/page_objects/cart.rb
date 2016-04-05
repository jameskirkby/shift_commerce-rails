module MyApp
  module Test
    module PageObject
      class Cart < CapybaraObjects::PageObject
        ptype "cart"
        locator :css, "body"
        def default_url
          "/cart"
        end
        # Custom validate! method to identify this page correctly as the
        # root node is the body which every page has.
        def validate!
          page.assert_title(I18n.t("carts.show.page_title"))
          super
        end

        # The cart view
        # @return [MyApp::Test::ComponentObject::Cart] The cart view
        def view
          get_component(:cart)
        end
      end
    end
  end
end