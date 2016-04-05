module MyApp
  module Test
    module ComponentObject
      class Registration < CapybaraObjects::ComponentObject
        ctype "registration"
        locator :css, "[data-behavior='account_register_view']"

        def register!(options = {})
          email_node.set(options[:email])
          password_node.set(options[:password])
          register_button_node.click
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

        def register_button_node
          scoped_find(:css, "[data-behavior='register_button']")
        end




      end
    end
  end
end