module MyApp
  module Test
    module ComponentObject
      class PaypalMiniCart < CapybaraObjects::ComponentObject
        ctype "paypal_mini_cart"
        locator :css, "#miniCart", wait: 30

        def assert_order_contents_present(cart:)
          (cart.line_items || []).each_with_index do |line_item, idx|
            line_item_at_index(idx).assert_equals(line_item)
          end

        end

        private

        def line_item_at_index(idx)
          get_component(:paypal_line_item, locator: [:xpath, ".//ul//ul[#{idx + 1}]"])
        end
      end
    end
  end
end