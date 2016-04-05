module MyApp
  module Test
    module ComponentObject
      class AddressItem < CapybaraObjects::ComponentObject
        ctype "address_item"
        locator :xpath, ".//*[@data-behavior='address']"

        def edit!
          edit_button_node.click
        end

        def delete!
          Capybara.current_session.accept_alert do
            delete_button_node.click
          end
        end

        def set_as_preferred_shipping!
          set_preferred_shipping_node.click
        end

        def set_as_preferred_billing!
          set_preferred_billing_node.click
        end

        def is_preferred_shipping?
          !!root_node["data-preferred-shipping"]
        end

        def is_preferred_billing?
          !!root_node["data-preferred-billing"]
        end

        private

        def edit_button_node
          scoped_find(:css, "*[data-action='edit']")
        end

        def delete_button_node
          scoped_find(:css, "*[data-action='delete']")
        end

        def set_preferred_shipping_node
          scoped_find(:css, "*[data-action='set_preferred_shipping']")
        end

        def set_preferred_billing_node
          scoped_find(:css, "*[data-action='set_preferred_billing']")
        end
      end
    end
  end
end