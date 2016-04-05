module MyApp
  module Test
    module PageObject
      class Addresses < CapybaraObjects::PageObject
        ptype "addresses"
        locator :css, "body"
        def default_url
          "/account/addresses"
        end
        # Custom validate! method to identify this page correctly as the
        # root node is the body which every page has.
        def validate!
          page.assert_title(I18n.t("addresses.index.page_title"))
          super
        end

        # The my addresses view
        # @return [MyApp::Test::ComponentObject::MyAddresses] The my addresses view
        def view
          get_component(:addresses)
        end
      end
    end
  end
end