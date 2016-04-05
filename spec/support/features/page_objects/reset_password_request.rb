module MyApp
  module Test
    module PageObject
      class ResetPasswordRequest < CapybaraObjects::PageObject
        ptype "reset_password_request"
        locator :css, "body"
        def default_url
          "/account/reset_password_request"
        end
        # Custom validate! method to identify this page correctly as the
        # root node is the body which every page has.
        def validate!
          page.assert_title(I18n.t("accounts.reset_password_request"))
          super
        end

        # The registration view
        # @return [MyApp::Test::ComponentObject::ResetPasswordRequest] The reset password request view
        def view
          get_component(:reset_password_request)
        end
      end
    end
  end
end