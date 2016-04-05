require 'rails_helper'
#
# This widget test tests a single instance of the widget, found on the specified "starting_page".
# it does not test every instance of the widget on all pages.
RSpec.feature "Widgets::TopNavigationSpecs", type: :feature do
  include_context "global widgets context"
  let(:widget) { page_object_for "top_navigation" }
  let(:starting_page) { page_object_for "entrance" }

  # The standard state is the state of the "starting_page" without doing anything such as logging in
  context "standard state" do
    # In this test suite, we are specifying that the top navigation should behave like a category navigation widget.
    # If, however, this was not required, a different shared example could be used or detailed spec added below to
    # validate both the content and functionality of the widget under test.
    it_should_behave_like "a category navigation widget"  # Defined in support/features/shared_examples/widgets/a_category_navigation_widget
  end
end
