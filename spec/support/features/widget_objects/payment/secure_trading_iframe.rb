module MyApp
  module Test
    module ComponentObject
      class SecureTradingIframe < CapybaraObjects::ComponentObject
        ctype "secure_trading_iframe"
        # @TODO Improve this selector
        locator :css, "iframe[name=\"secure_trading_iframe\"]"

        def select_payment_type(type)
          within_my_iframe do
            payment_type_node_for(type).click
          end
        end

        def pay_with_test_card(include_3d: false)
          within_my_iframe do
            card_number_node.set("4111111111111111")
            set_expiry_date(month: 1, year: 2020)
            security_code_node.set("123")
            pay_now_node.click
            if include_3d
              pin_node.set("sty") # A positive transaction
              three_d_submit_node.click
            end
          end


        end

        private

        def within_my_iframe(&blk)
          Capybara.current_session.within_frame("secure_trading_iframe", &blk)
        end

        def pin_node
          find(:css, "input[name=\"st_username\"]", wait: 30)
        end

        def three_d_submit_node
          find(:css,"input[value=\"Submit\"]")
        end

        def security_code_node
          find(:css, "input[name=\"securitycode\"]")
        end

        def set_expiry_date(month: 1, year: 2020)
          expiry_month_node.find(:css, "option[value='#{month.to_s.rjust(2, "0")}']").select_option
          expiry_year_node.find(:css, "option[value='#{year}']").select_option
        end

        def card_number_node
          find(:css, "input[name=\"pan\"]", wait: 30)
        end

        def expiry_month_node
          find(:css, "select[name=\"expirymonth\"]")
        end

        def expiry_year_node
          find(:css, "select[name=\"expiryyear\"]")
        end

        def pay_now_node
          find(:css, "input[value=\"Pay\"]")
        end

        def payment_type_node_for(type)
          find(:css, "input.paymentcard[title=\"#{type}\"]")
        end

      end
    end
  end
end
