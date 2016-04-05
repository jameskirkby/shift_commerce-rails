module MyApp
  module Test
    module ComponentObject
      class CategoryMenu < CapybaraObjects::ComponentObject
        ctype "category_menu"
        locator :css, "[data-behavior='category_navigation']"

        # Selects the menu item
        # @param [String] text The category title shown in the menu
        def select(text)
          node_for_category(text).click
        end

        private

        def node_for_category(text)
          scoped_find(:xpath, ".//*[@data-behavior='category_navigation_item' and .//*[text() = '#{text}']]")
        end

      end

    end
  end
end