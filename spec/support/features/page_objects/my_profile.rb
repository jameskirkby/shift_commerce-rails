module MyApp
  module Test
    module PageObject
      class MyProfile < CapybaraObjects::PageObject
        ptype "my_profile"
        locator :css, "body"
        def default_url
          "/account/edit"
        end
        # Custom validate! method to identify this page correctly as the
        # root node is the body which every page has.
        def validate!
          page.assert_title(I18n.t("accounts.edit.page_title"))
          super
        end

        # The my profile view
        # @return [MyApp::Test::ComponentObject::MyProfile] The my profile view
        def view
          get_component(:my_profile)
        end
      end
    end
  end
end