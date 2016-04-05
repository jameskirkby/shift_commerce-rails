module MyApp
  module Test
    module PageObject
      class StaticPage < CapybaraObjects::PageObject
        attr_accessor :static_page

        ptype "static_page"
        locator :css, "body"

        def default_url
          "/pages/#{static_page.slug}"
        end
        
        def static_page_view
          get_component :static_page_view
        end

        # This is for use with an example template setup in the seed data
        def static_page_view_for_example_template
          get_component :static_page_view_for_example_template
        end

        # Custom validate! method to identify this page correctly as the
        # root node is the body which every page has.
        def validate!
          page.assert_title(static_page.title)
          super
        end

      end
    end
  end
end