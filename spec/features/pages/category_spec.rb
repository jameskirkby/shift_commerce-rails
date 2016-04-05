require 'rails_helper'

RSpec.feature "Category product Browsing Specs", type: :feature, js: true do
  include_context "global pages context"
  let(:category_tree) { FlexCommerce::CategoryTree.find("slug:web") }
  let(:category) { category_tree.categories.detect {|c| c.title == "Baths"} }
  let(:product) { category.products[0] }
  let(:entrance) { page_object_for("entrance").visit }
  subject { page_object_for("category", category: category).attach }
  let(:product_page) { page_object_for("product", product: product).attach }
  context "with the first category selected from the menu" do
    it "should provide navigation down to product level starting from the list" do
      entrance.visit
      entrance.category_menu.select category.title
      expect(subject).to be_present
      subject.category_view.select_product(product.title)
      expect(product_page).to be_present
    end
  end
  context "a category with a template definition and template attributes" do
    subject { page_object_for("category", category: category).visit }
    let(:category) { category_tree.categories.detect { |c| c.reference=="home-furnishings" } }
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
      view = subject.category_view_for_example_template
      expect(view.colour_node).to have_text "red"
      expect(view.colour_node).to have_selector(:css, ".red")
      expect(view.size_node).to have_text "7"
    end
  end
end
