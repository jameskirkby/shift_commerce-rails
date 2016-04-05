require 'rails_helper'

RSpec.feature "Static Page Specs", type: :feature, js: true do
  include_context "global pages context"
  let(:static_page) { create(:static_page) }
  let(:starting_page) { page_object_for("static_page", static_page: static_page) }
  subject { starting_page.visit }

  it_should_behave_like "any site page" # Verifies common requirements across all pages
  context "Static Page" do

    let(:view) { subject.static_page_view }

    it "should have a static page widget" do
      expect(view).to be_present
    end

    it "should contain the page body content" do
      expect(view.body_content_node).to have_content(static_page.body_content)
    end
    context "a static page with a template definition and template attributes" do
      let(:static_page) { ::FlexCommerce::StaticPage.find("reference:delivery") }
      # We wouldn't normally have selenium type of things in here - it should be done in the
      # page objects, however, in this case, the html that we are testing for is really part
      # of the test itself, so it is quite valid - as we are testing to make sure the HTML output
      # hasnt been escaped.
      #
      # Also, for this test to make sense, you should know that the seed data in flex is setup
      # so that every 3 static pages starting at the second is setup to use the "StaticPage" template
      # definition which is configured with a "colour" attribute (HTML Editor!) and a "size"
      # attribute (integer) - the values are "<div class='red'></div>" and 7 respectively
      it "should display with the correct template" do
        view = subject.static_page_view_for_example_template
        expect(view.colour_node).to have_text "red"
        expect(view.colour_node).to have_selector(:css, ".red")
        expect(view.size_node).to have_text "7"
      end
    end

  end


end
