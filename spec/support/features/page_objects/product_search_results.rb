module MyApp
  module Test
    module PageObject
      class ProductSearchResults < CapybaraObjects::PageObject
        attr_accessor :search_text
        ptype "product_search_results"
        locator :css, "body"
        def default_url
          "/dummy_url"
        end
        # Custom validate! method to identify this page correctly as the
        # root node is the body which every page has.
        def validate!
          page.assert_title(I18n.t("products.search.page_title", search_text: search_text))
          super
        end

        def search_results_view
          get_component :search_results_view
        end
      end
    end
  end
end