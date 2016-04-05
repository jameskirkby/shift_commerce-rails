module MyApp
  module Test
    module ComponentObject
      class NewAddress < CapybaraObjects::ComponentObject
        ctype "new_address"
        locator :css, "[data-behavior='account_new_address_view']"

        def create_entry!(attributes)
          attributes.each_pair do |attr, value|
            next if attr == :country
            field_node_for_attr(attr).set(value)
          end
          field_node_for_attr(:country).find(:css, "option[value='#{attributes[:country]}']").select_option
          save_button_node.click
        end

        def assert_validation_errors(errors)
          errors.each_pair do |attr, errors|
            wrapper = field_node_for_attr(attr).parent
            errors.each do |error|
              wrapper.find(:css, "[data-behavior='#{attr}_field_error']", text: error)
            end
          end
        end


        private

        def field_node_for_attr(attr)
          scoped_find(:css, "*[name='address[#{attr}]']")
        end

        def save_button_node
          scoped_find(:css, "*[data-behavior='save_button']")
        end


      end
    end
  end
end