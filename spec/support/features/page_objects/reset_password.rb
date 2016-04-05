module MyApp
  module Test
    module PageObject
      class ResetPassword < CapybaraObjects::PageObject
        ptype "reset_password"
        locator :css, "body"
        def default_url
          "/account/reset_password"
        end
        # Custom validate! method to identify this page correctly as the
        # root node is the body which every page has.
        def validate!
          page.assert_title(I18n.t("accounts.reset_password"))
          super
        end

        # The reset password view
        # @return [MyApp::Test::ComponentObject::ResetPassword] The reset password view
        def view
          get_component(:reset_password)
        end
      end
    end
  end
end