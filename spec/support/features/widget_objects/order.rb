module MyApp
  module Test
    module ComponentObject
      class Order < CapybaraObjects::ComponentObject
        ctype "order"
        locator :css, "[data-behavior=\"order_view\"]"
        def assert_shipping_method(sm)
          scoped_find(:css, "[data-attribute=\"shipping_method_label\"]", text: sm.label)
        end
      end
    end
  end
end