module MyApp
  module Test
    module ComponentObject
      class ResetPassword < CapybaraObjects::ComponentObject
        ctype "reset_password"
        locator :css, "[data-behavior='account_new_password_view']"

        def password_reset!(options = {})
          password_node.set(options[:password])
          reset_button_node.click
        end

        private

        def password_node
          scoped_find(:css, "input[name='password[password]']")
        end

        def reset_button_node
          scoped_find(:css, "[data-behavior='reset_password_button']")
        end




      end
    end
  end
end