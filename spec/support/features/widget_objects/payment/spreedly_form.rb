module MyApp
  module Test
    module ComponentObject
      class SpreedlyIframe < CapybaraObjects::ComponentObject
        ctype "spreedly_form"
        locator :css, "[data-behavior=\"spreedly_form\"]"

        def pay_with_test_card
          name_node.set "Test User"
          set_card_number("4111111111111111")
          set_expiry_date(month: 1, year: 2020)
          set_security_code("123")
          pay_now_node.click
        end

        private

        def name_node
          scoped_find(:css, "[name=\"payment_setup[full_name]\"]")
        end

        def set_security_code(code)
          Capybara.current_session.within_frame("spreedly-cvv-frame") do
            find(:field, "verification_value").set(code)
          end
        end

        def set_expiry_date(month: 1, year: 2020)
          expiry_month_node.find(:css, "option[value='#{month.to_s.rjust(2, "0")}']").select_option
          expiry_year_node.find(:css, "option[value='#{year}']").select_option
        end

        def set_card_number(number)
          Capybara.current_session.within_frame("spreedly-number-frame") do
            find(:field, "number").set(number)
          end
        end

        def expiry_month_node
          scoped_find(:css, "select[name=\"payment_setup[month]\"]")
        end

        def expiry_year_node
          scoped_find(:css, "select[name=\"payment_setup[year]\"]")
        end

        def pay_now_node
          scoped_find(:css, "input[value=\"Pay Now\"]")
        end
      end
    end
  end
end