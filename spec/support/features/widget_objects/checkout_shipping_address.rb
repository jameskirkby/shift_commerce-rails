module MyApp
  module Test
    module ComponentObject
      class CheckoutShippingAddress < CapybaraObjects::ComponentObject
        FIELDS = [:first_name, :middle_names, :last_name, :address_line_1, :address_line_2, :address_line_3, :city, :state, :postcode]
        ctype "checkout_shipping_address"
        locator :css, "[data-behavior='checkout_shipping_address']"

        # Fills in the form with the address given
        # @param [MyApp::Test::Models::Address] address
        def update_entry!(address)
          FIELDS.each do |field|
            node_for_field(field).set(address.send(field))
          end
          node_for_field(:country).find(:css, "option[value='#{address.country}']").select_option
        end

        # Verifies that the list of options for the address is as specified (allowing for the "default" option as well)
        # @param [Integer[]] ids A list of ids of addresses that should be the only ones in the saved list
        def assert_saved_ids(ids)
          errors = []
          errors << "Expected list to have #{ids.length} items but it didn't" unless select_from_saved_node.has_selector?(:css, "option", count: ids.length + 1)
          ids.each do |id|
            begin
              select_from_saved_node.find(:css, "option[value=\"#{id}\"]")
            rescue Capybara::ExpectationNotMet => ex
              errors << "Expected list to contain id #{id} but it didn't - #{ex.message}"
            end
          end
          raise Capybara::ExpectationNotMet.new("Expected the saved ids list to equal #{ids} but but it didn't \n#{errors.join("\n")}") unless errors.empty?
        end

        # Validates that the shipping address equals the values given
        # @param [MyApp::Test::Models::Address] address
        def assert_shipping_address_equals(address, disabled: false)
          errors = []
          FIELDS.each do |field|
            begin
              root_node.assert_selector(:field, "cart[shipping_address_attributes][#{field}]", with: address.send(field), disabled: disabled)
            rescue Capybara::ExpectationNotMet => ex
              errors << "Field #{field} expectation not met.  #{ex.message}"
            end
          end
          raise Capybara::ExpectationNotMet.new(errors.join("\n")) unless errors.empty?
        end

        # Selects the given address as the shipping address
        # @param [MyApp::Test::Models::Address] address
        def select_from_saved(address)
          select_address_from_saved(address)
        end

        # Selects the "I'll enter it manually option" which is the option with an empty value
        def select_manual!
          select_from_saved_node.find(:css, "option[value='']").select_option
        end



        # Verifies that the fields are marked with the errors specified
        # The errors are the same as active record errors
        def assert_validation_errors(errors)
          errors.each_pair do |attr, errors|
            wrapper = node_for_field(attr).parent
            errors.each do |error|
              wrapper.find(:css, "[data-behavior='#{attr}_field_error']", text: error)
            end
          end
        end

        def assert_all_fields_empty
          FIELDS.each do |field|
            root_node.assert_selector(:field, "cart[shipping_address_attributes][#{field}]", with: "")
          end
        end

        def assert_all_fields_disabled
          FIELDS.each do |field|
            root_node.assert_selector(:css, "*[name='cart[shipping_address_attributes][#{field}]'][disabled]")
          end
        end

        def allow_edit!
          allow_edit_node.set(true)
        end

        private

        def select_from_saved_node
          scoped_find(:css, "select[name='cart[shipping_address_id]']")
        end

        def select_address_from_saved(address)
          select_from_saved_node.find(:css, "option[value='#{address.id}']").select_option
        end

        def node_for_field(field)
          scoped_find(:css, "*[name='cart[shipping_address_attributes][#{field}]']")
        end

        def allow_edit_node
          scoped_find(:css, "*[name='cart[allow_edit_shipping_address]']")
        end

      end
    end
  end
end