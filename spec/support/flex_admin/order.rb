require_relative "./base"
require_relative "./line_item"
module MyApp
  module Test
    module Models
      class Order < Base
        has_many :line_items
      end
    end
  end
end