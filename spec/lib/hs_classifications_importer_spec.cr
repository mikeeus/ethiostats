require "csv"
require "../spec_helper.cr"

describe HsClassificationImporter do
  # First we import the test classifications
  Spec.before_each do
    import_test_hs_classifications
  end

  # NOTE: `spec_helper` truncates the database after each test
  # so I'm putting the tests in a single block to avoid
  # multiple database calls.
  it "imports sections, chapters and headings" do
    # "imports sectinons with zeroed children"
    section_code = "01"
    zeroed_chapter_code = "0100"
    zeroed_heading_code = "010000"
    SectionQuery.new.code(section_code).first?.should_not be nil
    ChapterQuery.new.code(zeroed_chapter_code).first?.should_not be nil
    HeadingQuery.new.code(zeroed_heading_code).first?.should_not be nil

    # "imports chapter with zeroed headings"
    ChapterQuery.new.code("0101").first?.should_not be nil
    zeroed_heading_code = "010100"
    HeadingQuery.new.code(zeroed_heading_code).first?.should_not be nil

    # "imports headings by themselves" do
    heading_desc = "(2002-2011) - Pure-bred breeding animals"
    HeadingQuery.new.code("010110").first.description.should eq heading_desc
  end
end
