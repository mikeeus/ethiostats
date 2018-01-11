require "csv"
require "../spec_helper.cr"
require "../support/factories.cr"

describe HsClassificationImporter do
  # First we import the test classifications
  Spec.before_each do
    seed_hs_classifications
  end

  # NOTE: `spec_helper` truncates the database after each test
  # so I'm nesting the tests in a single it block to avoid
  # multiple database calls.
  it "imports sections, chapters and headings" do
    it "section with zeroed children" do
      section_code = "01"
      zeroed_chapter_code = "0100"
      zeroed_heading_code = "010000"
      SectionQuery.new.code(section_code).first?.should_not be nil
      ChapterQuery.new.code(zeroed_chapter_code).first?.should_not be nil
      HeadingQuery.new.code(zeroed_heading_code).first?.should_not be nil
    end

    it "chapter with zeroed headings" do
      ChapterQuery.new.code("0101").first?.should_not be nil
      zeroed_heading_code = "010100"
      HeadingQuery.new.code(zeroed_heading_code).first?.should_not be nil
    end

    it "heading by itself" do
      heading_desc = "(2002-2011) - Pure-bred breeding animals"
      HeadingQuery.new.code("010110").first.description.should eq heading_desc
    end
  end
end
