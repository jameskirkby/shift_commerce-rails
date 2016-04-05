module MyApp
  module Test
    module ComponentObject
      class SearchResultsView < CapybaraObjects::ComponentObject
        include XPath
        ctype "search_results_view"
        locator :css, "[data-behavior='search_results_view']"

        def select_product(text)
          scoped_find(:css, "a", text: text).click
        end

        def empty_text_node
          scoped_find(:css, "p", text: I18n.t("products.search.empty"))
        end
      end
    end
  end
end