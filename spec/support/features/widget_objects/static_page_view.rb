module MyApp
  module Test
    module ComponentObject
      class StaticPageView < CapybaraObjects::ComponentObject
        ctype "static_page_view"
        locator :css, "[data-behavior='static_page_content']"

        def body_content_node
          root_node
        end

      end
    end
  end
end
