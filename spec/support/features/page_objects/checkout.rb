module MyApp
  module Test
    module PageObject
      class Checkout < CapybaraObjects::PageObject
        ptype "checkout"
        locator :css, "body"
        def default_url
          "/cart/edit"
        end
        # Custom validate! method to identify this page correctly as the
        # root node is the body which every page has.
        def validate!
          page.assert_title(I18n.t("carts.edit.page_title"))
          super
        end

        # The checkout view
        # @return [MyApp::Test::ComponentObject::Checkout] The checkout view
        def view
          get_component(:checkout)
        end

      end
    end
  end
end