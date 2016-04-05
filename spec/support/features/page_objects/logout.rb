module MyApp
  module Test
    module PageObject
      class Logout < CapybaraObjects::PageObject
        ptype "logout"
        locator :css, "body"
        def default_url
          "/account/logout"
        end
        # Custom validate! method to identify this page correctly as the
        # root node is the body which every page has.
        def validate!
          page.assert_title(I18n.t("account_sessions.destroy.page_title"))
          super
        end


        # The logout view
        # @return [MyApp::Test::ComponentObject::Logout] The logout view
        def view
          get_component(:logout)
        end
      end
    end
  end
end