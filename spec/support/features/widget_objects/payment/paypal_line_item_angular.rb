module MyApp
  module Test
    module ComponentObject
      class PaypalLineItemAngular < CapybaraObjects::ComponentObject
        ctype "paypal_line_item_angular"
        locator :css, "#unused"

        def assert_equals(line_item)
          scoped_find(:css, ".itemName", text: line_item.title, visible: false)
          scoped_find(:css, ".itemPrice", text: "£#{line_item.total}", visible: false)

        end
      end
    end
  end
end
