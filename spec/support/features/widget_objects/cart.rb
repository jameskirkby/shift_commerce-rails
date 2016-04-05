module MyApp
  module Test
    module ComponentObject
      class Cart < CapybaraObjects::ComponentObject
        ctype "cart"
        locator :css, "[data-behavior=\"cart_view\"]"

        # Tests for the empty wording - to indicate if the cart is empty
        # @return [Boolean] true if empty else false
        def empty?
          root_node.has_text?(I18n.t("carts.show.empty"))
          true
        rescue Capybara::ElementNotFound
          false
        end

        # Verifies that the number of line items matches the specified quantity
        # @param [Integer] qty The expected number of line items
        def assert_line_item_quantity(qty)
          root_node.assert_selector(:css, "[data-behavior='cart_line_item']", count: qty)
        end

        # Verifies that the number of discount summaries matches the specified quantity
        # @param [Integer] qty The expected number of discount summaries
        def assert_discount_summary_quantity(qty)
          root_node.assert_selector(:css, "[data-behavior=\"cart_discount_summary\"]", count: qty)
        end

        def within_row(idx)
          yield row_at_index(idx)
        end

        def increase_quantity_for_row(idx)
          within_row idx do |row|
            row.increase_quantity
          end
        end

        def decrease_quantity_for_row(idx)
          within_row idx do |row|
            row.decrease_quantity
          end
        end

        def summary
          get_component(:cart_summary)
        end

        def checkout!
          checkout_button_node.click
        end

        def discount_summary_row_at_index(idx)
          get_component(:cart_discount_summary, locator: [:xpath, ".//*[@data-behavior='cart_discount_summary'][#{idx + 1}]"])
        end

        def add_coupon!(code)
          coupon_code_node.set(code)
          update_button_node.click
        end

        def select_paypal
          paypal_link_node.click
        end

        private

        def paypal_link_node
          scoped_find(:css, "*[data-action='select_paypal']")
        end

        def coupon_code_node
          scoped_find(:css, "[data-input='coupon_code']")
        end

        def update_button_node
          scoped_find(:css, "[data-action='update_cart']")
        end

        def row_at_index(idx)
          get_component(:cart_line_item, locator: [:xpath, ".//*[@data-behavior='cart_line_item'][#{idx + 1}]"])
        end

        def checkout_button_node
          scoped_find(:css, "[data-action='checkout']")
        end
      end
    end
  end
end