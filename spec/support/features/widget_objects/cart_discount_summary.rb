module MyApp
  module Test
    module ComponentObject
      class CartDiscountSummary < CapybaraObjects::ComponentObject
        ctype "cart_discount_summary"
        locator :css, "[data-behavior='cart_discount_summary']"

        def name_node
          scoped_find :css, "[data-attribute='name']"
        end

        def total_node
          scoped_find :css, "[data-attribute='total']"
        end
      end
    end
  end
end