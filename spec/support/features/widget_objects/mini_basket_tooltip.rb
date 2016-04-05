module MyApp
  module Test
    module ComponentObject
      class MiniBasketTooltip < CapybaraObjects::ComponentObject
        ctype "mini_basket_tooltip"
        locator :css, "[data-behavior='mini_basket_contents']"

        # The number of line items visible in the tooltip
        # @return [Integer] The number of line items
        def row_count
          root_node.all(:css, "[data-behavior='cart_line_item']").count
        end

        # The node containing the basket total
        # @return [Capybara::Node] The basket total node
        def total
          scoped_find(:css, "[data-behavior='mini_basket_summary'] [data-attribute='total']")
        end

        # The node containing the basket sub total
        # @return [Capybara::Node] The basket sub total node
        def sub_total
          scoped_find(:css, "[data-behavior='mini_basket_summary'] [data-attribute='sub_total']")
        end

        # Indicates the basket is empty by looking for the appropriate empty text
        # @return [Boolean] Indicates if the basket is empty
        def empty?
          root_node.has_text? I18n.t("shared.mini_basket.empty_basket")
        end

        # Clicks the edit cart button
        def edit_cart!
          edit_cart_button.click
        end

        # Clicks the checkout button
        def checkout!
          checkout_button.click
        end

        # Verifies that the number of discount summaries matches the specified quantity
        # @param [Integer] qty The expected number of discount summaries
        def assert_discount_summary_quantity(qty)
          root_node.assert_selector(:css, "[data-behavior='cart_discount_summary']", count: qty)
        end

        def discount_summary_row_at_index(idx)
          get_component(:cart_discount_summary, locator: [:xpath, ".//*[@data-behavior='cart_discount_summary'][#{idx + 1}]"])
        end


        private

        def edit_cart_button
          scoped_find(:css, "[data-action='edit_basket']")
        end

        def checkout_button
          scoped_find(:css, "[data-action='checkout']")
        end

      end
    end
  end
end