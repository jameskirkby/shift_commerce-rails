module MyApp
  module Test
    module PageObject
      class Registration < CapybaraObjects::PageObject
        ptype "registration"
        locator :css, "body"
        def default_url
          "/account/new"
        end
        # Custom validate! method to identify this page correctly as the
        # root node is the body which every page has.
        def validate!
          page.assert_title(I18n.t("accounts.new.page_title"))
          super
        end

        # The registration view
        # @return [MyApp::Test::ComponentObject::Registration] The registration view
        def view
          get_component(:registration)
        end
      end
    end
  end
end