module MyApp
  module Test
    module ComponentObject
      class Logout < CapybaraObjects::ComponentObject
        ctype "logout"
        locator :css, "[data-behavior='account_logout_view']"

      end
    end
  end
end