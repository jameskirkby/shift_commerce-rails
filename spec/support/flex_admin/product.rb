require_relative "./base"
module MyApp
  module Test
    module Models
      class Product < Base
        has_many :variants
      end
    end
  end
end