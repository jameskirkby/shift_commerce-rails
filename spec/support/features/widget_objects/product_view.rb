module MyApp
  module Test
    module ComponentObject
      class ProductView < CapybaraObjects::ComponentObject
        ctype "product_view"
        locator :css, "[data-behavior='product_view']"
        # The title node
        # @return [Capybara::Node] The node that contains the title
        def title
          scoped_find(:css, "[data-attribute='title']")
        end
        # The price node
        # @return [Capybara::Node] The node that contains the price
        def price
          scoped_find(:css, "[data-product-attribute='price']")
        end
        # The description node
        # @return [Capybara::Node] The node that contains the description
        def description
          scoped_find(:css, "[data-product-attribute='description']")
        end
        # The variant selector
        # @return [MyApp::Test::ComponentObject::ProductVariantSelector] The variant selector component
        def variant_selector
          get_component(:product_variant_selector)
        end

        # Adds the selected variant to the basket
        # @param [Hash] options The options
        # @option options [Integer] :quantity The quantity to add (leaves the quantity field alone if not specified)
        def add_to_basket!(options = {})
          quantity_node.set(options[:quantity]) if options.key?(:quantity)
          add_to_basket_node.click
        end

        private

        def quantity_node
          scoped_find(:css, "[name=\"line_item[unit_quantity]\"]")
        end

        def add_to_basket_node
          scoped_find(:css, "[data-action='add_to_basket']")
        end

      end
    end
  end
end