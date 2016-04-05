module MyApp
  module Test
    module PageObject
      class Login < CapybaraObjects::PageObject
        ptype "login"
        locator :css, "body"
        def default_url
          "/account/login"
        end
        # Custom validate! method to identify this page correctly as the
        # root node is the body which every page has.
        def validate!
          page.assert_title(I18n.t("account_sessions.new.page_title"))
          super
        end


        # The login view
        # @return [MyApp::Test::ComponentObject::Login] The login view
        def view
          get_component(:login)
        end
      end
    end
  end
end