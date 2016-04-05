module MyApp
  module Test
    module ComponentObject
      class Addresses < CapybaraObjects::ComponentObject
        ctype "addresses"
        locator :css, "[data-behavior='account_addresses_index_view']"

        def address_at_index(idx)
          get_component(:address_item, locator: [:xpath, ".//*[@data-behavior='address'][#{idx + 1}]"])
        end

        private



      end
    end
  end
end