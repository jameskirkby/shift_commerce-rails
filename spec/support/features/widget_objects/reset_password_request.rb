module MyApp
  module Test
    module ComponentObject
      class ResetPasswordRequest < CapybaraObjects::ComponentObject
        ctype "reset_password_request"
        locator :css, "[data-behavior='account_reset_password_request_view']"

        def request_password_reset!(options = {})
          email_node.set(options[:email])
          reset_button_node.click
        end

        private

        def email_node
          scoped_find(:css, "input[name='reset[email]']")
        end

        def reset_button_node
          scoped_find(:css, "[data-behavior='reset_password_request_button']")
        end




      end
    end
  end
end