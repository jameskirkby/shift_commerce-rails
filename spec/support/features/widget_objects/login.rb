module MyApp
  module Test
    module ComponentObject
      class Login < CapybaraObjects::ComponentObject
        ctype "login"
        locator :css, "[data-behavior='account_login_view']"

        def login!(options = {})
          email_node.set(options[:email])
          password_node.set(options[:password])
          login_button_node.click
        end

        def assert_validation_errors(errors)
          errors.each_pair do |field, errors|
            wrapper = send("#{field}_node").parent
            errors.each do |error|
              wrapper.find(:css, "[data-behavior='#{field}_field_error']", text: error)
            end
          end
        end

        private

        def email_node
          scoped_find(:css, "input[name='account[email]']")
        end

        def password_node
          scoped_find(:css, "input[name='account[password]']")
        end

        def login_button_node
          scoped_find(:css, "[data-behavior='login_button']")
        end
      end
    end
  end
end