module MyApp
  module Test
    module PageObject
      class EditAddress < CapybaraObjects::PageObject
        attr_accessor :address
        ptype "edit_address"
        locator :css, "body"
        def default_url
          "/account/addresses/#{address.id}/edit"
        end
        # Custom validate! method to identify this page correctly as the
        # root node is the body which every page has.
        def validate!
          page.assert_title(I18n.t("addresses.edit.page_title"))
          super
        end

        # The my addresses view
        # @return [MyApp::Test::ComponentObject::EditAddress] The my addresses view
        def view
          get_component(:edit_address)
        end
      end
    end
  end
end