module MyApp
  module Test
    module PageObject
      class NewAddress < CapybaraObjects::PageObject
        ptype "new_address"
        locator :css, "body"
        def default_url
          "/account/addresses/new"
        end
        # Custom validate! method to identify this page correctly as the
        # root node is the body which every page has.
        def validate!
          page.assert_title(I18n.t("addresses.new.page_title"))
          super
        end

        # The my addresses view
        # @return [MyApp::Test::ComponentObject::NewAddress] The my addresses view
        def view
          get_component(:new_address)
        end
      end
    end
  end
end