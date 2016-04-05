module MyApp
  module Test
    module ComponentObject
      class PaypalLineItem < CapybaraObjects::ComponentObject
        ctype "paypal_line_item"
        locator :css, "#unused"

        def assert_equals(line_item)
          scoped_find(:css, ".name .accessAid", text: line_item.title, visible: false)
          scoped_find(:css, ".amount", text: "£#{line_item.total}")
          scoped_find(:css, "li.secondary .accessAid", text: line_item.title, visible: false)
          scoped_find(:css, "li", text: "Quantity: #{line_item.unit_quantity}")

        end
      end
    end
  end
end
=begin
 The root looks like this
                    <ul class="item1">
                        <li class="dark"><span class="name"><a class="autoTooltip" href="#name0" title=""
                                                               id="showname0">Variant 2 for Product 1 - Awesome G…<span
                                class="accessAid">Variant 2 for Product 1 - Awesome Granite Knife</span></a></span><span
                                class="amount">£4.29</span></li>
                        <li class="secondary">Item description: <a class="autoTooltip" href="#desc0" title=""
                                                                   id="showdesc0">Variant 2 for Prod…<span
                                class="accessAid">Variant 2 for Product 1 - Awesome Granite Knife</span></a></li>
                        <li class="secondary">Item number: Number</li>
                        <li class="secondary"><span>Item price: £4.29</span></li>
                        <li class="secondary">Quantity: 1</li>
                    </ul>

=end
