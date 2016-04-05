module MyApp
  module Test
    module ComponentObject
      class Header < CapybaraObjects::ComponentObject
        ctype "header"
        locator :css, "*[data-behavior='header']"

        def mini_basket
          get_component :mini_basket
        end

        def mini_search
          get_component :mini_search
        end

        # Provides access to the customer account widget
        # @return [MyApp::Test::ComponentObject::CustomerAccount] The customer account widget
        def customer_account
          get_component :customer_account
        end

        # Performs a search operation from expanding the form through to submitting it
        def search!(text)
          mini_search.search!(text)
        end

      end
    end
  end
end