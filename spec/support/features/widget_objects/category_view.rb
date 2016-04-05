module MyApp
  module Test
    module ComponentObject
      class CategoryView < CapybaraObjects::ComponentObject
        include XPath
        ctype "category_view"
        locator :css, "[data-behavior='category_view']"

        def select_product(text)
          scoped_find(:css, "a", text: text).click
        end

        def empty_text_node
          scoped_find(:css, "p", text: I18n.t("categories.show.empty_products"))
        end
      end
    end
  end
end