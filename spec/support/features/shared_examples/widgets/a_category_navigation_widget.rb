RSpec.shared_examples_for "a category navigation widget" do
  context "appearance" do
    it "should have at least the first n categories visible"
  end
  context "functionality" do
    it "should show more details about the category on hover over of every visible category", touch: false
    it "should show the correct page when each category is clicked"
  end
end