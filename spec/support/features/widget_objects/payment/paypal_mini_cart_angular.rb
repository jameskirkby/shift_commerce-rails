module MyApp
  module Test
    module ComponentObject
      class PaypalMiniCartAngular < CapybaraObjects::ComponentObject
        ctype "paypal_mini_cart_angular"
        locator :css, "xo-cart", wait: 30

        def assert_order_contents_present(cart:)
          (cart.line_items || []).each_with_index do |line_item, idx|
            line_item_at_index(idx).assert_equals(line_item)
          end

        end

        private

        def line_item_at_index(idx)
          get_component(:paypal_line_item_angular, locator: [:xpath, ".//ul[contains(@class, \"detail-items\")]/li[#{idx + 1}]", visible: false])
        end
      end
    end
  end
end