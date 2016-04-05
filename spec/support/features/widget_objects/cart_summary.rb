module MyApp
  module Test
    module ComponentObject
      class CartSummary < CapybaraObjects::ComponentObject
        ctype "cart_summary"
        locator :css, "[data-behavior='cart_summary']"

        def total_node
          scoped_find :css, "[data-attribute='total']"
        end

        def sub_total_node
          scoped_find :css, "[data-attribute='sub_total']"
        end
      end
    end
  end
end