module MyApp
  module Test
    module PageObject
      class Entrance < CapybaraObjects::PageObject
        ptype "entrance"
        locator :css, "body"
        def default_url
          "/"
        end
        def header
          get_component :header
        end
        # Provides access to the category menu
        # @return [MyApp::Test::ComponentObject::CategoryMenu] The category menu
        def category_menu
          get_component :category_menu
        end

      end
    end
  end
end