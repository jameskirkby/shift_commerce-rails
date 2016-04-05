module MyApp
  module Test
    module Models
      class Category < Base
        has_many :products

      end
    end
  end
end