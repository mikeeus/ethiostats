require "../spec_helper"

describe "Homepage" do
  describe "/" do
    visitor = AppVisitor.new

    Spec.before_each do
      visitor = AppVisitor.new
      visitor.visit("/")
    end

    it "visits the homepage" do
      it "shows a title" do
        visitor.should contain "<title>Ethiostats</title>"
      end

      it "shows a graph" do
        visitor.visit("/")
        visitor.should contain "<h2>Latest Posts</h2>"
      end

      it "shows a searchbar for Hscodes" do
        visitor.visit("/")
        visitor.should contain "<h2>Latest Posts</h2>"
      end
    end
  end
end
