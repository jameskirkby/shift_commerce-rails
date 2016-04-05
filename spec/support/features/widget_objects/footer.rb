module MyApp
  module Test
    module ComponentObject
      class Footer < CapybaraObjects::ComponentObject
        ctype "footer"
        locator :css, "footer.mt-site-footer"


        # @return [MyApp::Test::ComponentObject::Registration] The registration widget
        def registration
          get_component(:registration)
        end
      end

    end
  end
end