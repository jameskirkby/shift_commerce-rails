module MyApp
  module Test
    module ComponentObject
      class CustomerAccount < CapybaraObjects::ComponentObject
        ctype "customer_account"
        locator :css, "[data-behavior='customer_account']"

        # Requests the login page
        def login!
          button_node.click
        end

        # Requests the user logs out
        def logout!
          expand!
          logout_button_node.click
        end

        def expand!
          expand_button_node.click
        end

        private

        def button_node
          scoped_find(:css, "a[data-action='login']")
        end

        def logout_button_node
          scoped_find(:css, "a[data-action='logout']")
        end

        def expand_button_node
          scoped_find(:css, "a[data-action='expand']")
        end

      end
    end
  end
end