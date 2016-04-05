require_relative "./base"
module MyApp
  module Test
    module Models
      class Cart < Base
        has_many :line_items
        has_one :shipping_address, class_name: "Address"
        has_one :shipping_address, class_name: "Address"
      end
    end
  end
end