module MyApp
  module Test
    module ComponentObject
      class MiniSearch < CapybaraObjects::ComponentObject
        ctype "mini_search"
        locator :css, "[data-behavior='mini_search']"

        def search!(text)
          ensure_form_is_expanded!
          search_input_node.set(text)
          submit!
        end

        # no need to submit, ajax should do it
        def suggestive_search(text)
          ensure_form_is_expanded!
          search_input_node.set(text)
        end

        def assert_suggestions(expectations)
          expectations.each do |expectation|
            scoped_find(:css, ".tt-suggestion", text: expectation)
          end
        end

        private
        def ensure_form_is_expanded!
          # We now do nothing here as the form is always present
        end

        def click_search_icon!
          search_icon_node.click
        end

        def search_icon_node
          scoped_find(:css, "[data-action='expand_search']")
        end

        def search_input_node
          scoped_find(:css, "[data-attribute='query']")
        end

        def submit!
          submit_node.click
        end

        def submit_node
          scoped_find(:css, "[data-action='submit_search']")
        end

      end
    end
  end
end