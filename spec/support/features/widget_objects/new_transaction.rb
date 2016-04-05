module MyApp
  module Test
    module ComponentObject
      class NewTransaction < CapybaraObjects::ComponentObject
        ctype "new_transaction"
        locator :css, "[data-behavior='new_transaction_view']"

        def select_paypal
          paypal_link_node.click
        end

        def select_spreedly
          spreedly_link_node.click
        end

        def select_secure_trading
          secure_trading_link_node.click
        end

        def spreedly
          get_component(:spreedly_form)
        end

        def secure_trading
          get_component(:secure_trading_iframe)
        end

        private

        def paypal_link_node
          scoped_find(:css, "*[data-action='select_paypal']")
        end

        def spreedly_link_node
          scoped_find(:css, "*[data-action='select_spreedly']")
        end

        def secure_trading_link_node
          scoped_find(:css, "*[data-action='select_secure_trading']")
        end
# This is what a mini cart looks like in paypals page
=begin
<div id="miniCart" class=""><h3>Your order summary</h3>

    <div class="small head wrap">Descriptions<span class="amount">Amount</span></div>
    <ol class="small wrap items limit-a">
        <li class="seller1">
            <ul>
                <li id="multiitem1" class="itmdet">
                    <ul class="item1">
                        <li class="dark"><span class="name"><a class="autoTooltip" href="#name0" title=""
                                                               id="showname0">Name<span
                                class="accessAid">Name</span></a></span><span class="amount">£5.00</span></li>
                        <li class="secondary">Item description: Description</li>
                        <li class="secondary">Item number: Number</li>
                        <li class="secondary"><span>Item price: £5.00</span></li>
                        <li class="secondary">Quantity: 1</li>
                    </ul>
                    <ul>
                        <li class="dark"><span class="name"><a class="autoTooltip" href="#name1" title=""
                                                               id="showname1">Name<span
                                class="accessAid">Name</span></a></span><span class="amount">£5.00</span></li>
                        <li class="secondary">Item description: Description</li>
                        <li class="secondary">Item number: Number</li>
                        <li class="secondary"><span>Item price: £5.00</span></li>
                        <li class="secondary">Quantity: 1</li>
                    </ul>
                    <ul></ul>
                </li>
            </ul>
        </li>
    </ol>
    <div class="wrap items totals item1">
        <ul>
            <li class="small heavy">Item total<span class="amount">£10.00</span></li>
        </ul>
    </div>
    <div class="small wrap items totals item1">
        <ul>
            <li class="heavy highlight finalTotal"><span class="grandTotal amount highlight">Total £10.00 GBP</span>
            </li>
        </ul>
    </div>
    <div>
        <div></div>
        <div></div>
    </div>
</div>
=end
      end
    end
  end
end