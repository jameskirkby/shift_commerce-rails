module MyApp
  module Test
    module ComponentObject
      # This component object is for use with the example "StaticPage" template definition in the seed data
      class StaticPageViewForExampleTemplate < CapybaraObjects::ComponentObject
        ctype "static_page_view_for_example_template"
        locator :css, "[data-behavior='static_page_view_for_example_template']"

        def colour_node
          scoped_find(:css, "[data-attribute='colour']")
        end

        def size_node
          scoped_find(:css, "[data-attribute='size']")
        end
      end
    end
  end
end