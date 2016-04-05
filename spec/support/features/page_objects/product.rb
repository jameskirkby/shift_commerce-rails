module MyApp
  module Test
    module PageObject
      class Product < CapybaraObjects::PageObject
        attr_accessor :product
        ptype "product"
        locator :css, "body"
        def default_url
          "/products/#{product.slug}"
        end
        # Custom validate! method to identify this page correctly as the
        # root node is the body which every page has.
        def validate!
          page.assert_title(product.title)
          super
        end

        def product_view
          get_component :product_view
        end

        # This is for use with an example template setup in the seed data
        def product_view_for_example_template
          get_component :product_view_for_example_template
        end
      end
    end
  end
end