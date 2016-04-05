module MyApp
  module Test
    module PageObject
      class Category < CapybaraObjects::PageObject
        attr_accessor :category
        ptype "category"
        locator :css, "body"
        def default_url
          "/categories/web/#{category.slug}"
        end
        # Custom validate! method to identify this page correctly as the
        # root node is the body which every page has.
        def validate!
          page.assert_title("Products in #{category.title}", wait: 10)
          super
        end

        def category_view
          get_component :category_view
        end

        # This is for use with an example template setup in the seed data
        def category_view_for_example_template
          get_component :category_view_for_example_template
        end
      end
    end
  end
end