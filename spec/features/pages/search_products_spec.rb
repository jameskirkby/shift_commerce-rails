require 'rails_helper'

RSpec.feature "Product Searching Specs", type: :feature, js: true do
  include_context "global pages context"
  let(:category_tree) { FlexCommerce::CategoryTree.find("slug:web") }
  let(:category) { category_tree.categories.detect {|c| c.title == "Baths"} }
  let(:product) { category.products[0] }
  let(:entrance) { page_object_for("entrance").visit }
  subject { page_object_for("product_search_results", search_text: search_text).attach }
  let(:product_page) { page_object_for("product", product: product).attach }
  context "searching for a known product" do
    let(:search_text) { product.title.split(" ").slice(-3, 3).join(" ") }
    it " while typing a search term" do
      entrance.visit
      entrance.header.search! search_text
      expect(subject).to be_present
      subject.search_results_view.select_product(product.title)
      expect(product_page).to be_present
    end
  end
  context "searching for a word that doesn't exist anywhere" do
    let(:search_text) { "supercalifragilisticexpialidocious" }
    it "should show products" do
      entrance.visit
      entrance.header.search! search_text
      expect(subject).to be_present
      expect(subject.search_results_view.empty_text_node).to be_present
    end
  end

  context "Suggestive search" do
    let(:search_text) { product.title.split(" ").slice(-3, 3).join(" ") }
    it "should prefetch suggestions when the user hesitates while typing a search term" do
      entrance.visit
      entrance.header.mini_search.suggestive_search search_text
      entrance.header.mini_search.assert_suggestions([product.title])
    end
  end
end
