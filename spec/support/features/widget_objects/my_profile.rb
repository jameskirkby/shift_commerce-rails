module MyApp
  module Test
    module ComponentObject
      class MyProfile < CapybaraObjects::ComponentObject
        ctype "my_profile"
        locator :css, "[data-behavior='account_edit_view']"

        def email_node
          scoped_find(:css, "input[name='account[email]']")
        end

        def update_email!(value)
          email_node.set(value)
          save_button_node.click
        end

        def update_twitter_username!(value)
          twitter_username_node.set(value)
          save_button_node.click
        end

        def twitter_username_node
          scoped_find(:css, "#twitter_username")
        end

        private

        def save_button_node
          scoped_find(:css, "[data-behavior='save_button']")
        end
      end
    end
  end
end
