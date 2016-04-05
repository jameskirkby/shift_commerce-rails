require_relative "./base"
module MyApp
  module Test
    module Models
      class CustomerAccount < Base
        has_many :addresses
      end
    end
  end
end