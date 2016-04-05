module MyApp
  module Test
    module PageObject
      class NewTransaction < CapybaraObjects::PageObject
        ptype "new_transaction"
        locator :css, "body"
        def default_url
          "/cart/transactions/new"
        end
        # Custom validate! method to identify this page correctly as the
        # root node is the body which every page has.
        def validate!
          page.assert_title(I18n.t("transactions.new.page_title"), wait: 30)
          super
        end

        # The checkout view
        # @return [MyApp::Test::ComponentObject::NewTransaction] The checkout view
        def view
          get_component(:new_transaction)
        end

      end
    end
  end
end