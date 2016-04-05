module MyApp
  module Test
    module ComponentObject
      class ProductVariantSelector < CapybaraObjects::ComponentObject
        ctype "product_variant_selector"
        locator :css, "[data-behavior='product_variant_selector']"

        # The variant titles within the selector

        # @return [String[]] An array of the titles
        def titles
          select_node.all(:css, "option").map(&:text)
        end

        # Selects a variant by its text in the selector
        # @param [String] text The option to select
        def select(text)
          select_node.select(text)
        end
        private

        def select_node
          scoped_find(:css, "select")
        end
      end
    end
  end
end