module MyApp
  module Test
    module ComponentObject
      class CartLineItem < CapybaraObjects::ComponentObject
        ctype "cart_line_item"
        locator :css, "[data-behavior='cart_line_item']"

        def title_node
          scoped_find :css, "[data-attribute='title']"
        end

        def price_node
          scoped_find :css, "[data-attribute='unit_price']"
        end

        def total_node
          scoped_find :css, "[data-attribute='total']"
        end

        def quantity_node
          scoped_find :css, "[data-attribute='unit_quantity']"
        end

        def increase_quantity
          increase_quantity_button_node.click
        end

        def decrease_quantity
          decrease_quantity_button_node.click
        end

        private

        def increase_quantity_button_node
          scoped_find :css, "[data-behavior='add_one_line_item']"
        end
        def decrease_quantity_button_node
          scoped_find :css, "[data-behavior='remove_one_line_item']"
        end
      end
    end
  end
end