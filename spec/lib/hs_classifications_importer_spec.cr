require "csv"
require "../spec_helper.cr"
require "../../src/lib/hs_classification_importer.cr"

# We can use CSV.build to easily create a CSV string
data = CSV.build do |csv|
  csv.row "NomenclatureCode","Tier","ProductCode","Product Description"
  csv.row "HS","0"," Total","Total Trade"
  csv.row "HS","1","01","LIVE ANIMALS"
  csv.row "HS","2","0101","Live horses, asses, mules and hinnies."
  csv.row "HS","3","010110","(2002-2011) - Pure-bred breeding animals"
end

describe HsClassificationImporter do
  # We'll import the csv before each test
  Spec.before_each do
    length = CSV.parse(data).size
    HsClassificationImporter.new(CSV.new(data, headers: true), length, false).call
  end

  # And clear the the table afterwards
  #
  # NOTE: deleting sections will destroy their chapters and headings because we
  # set on_delete: :cascade when creating the associations
  Spec.after_each do
    LuckyRecord::Repo.run { |db| db.exec "DELETE FROM sections;" }
  end

  # NOTE: I include all the tests in a single bock to avoid multiple calls to
  # the db. There is no `Spec.before_all` method, so this will have to do for
  # now.
  it "imports sections, chapters and headings with zeroed children" do
    # Lets check that the first section was added with it's zeroed chapter and
    # heading
    section_code = "01"
    zeroed_chapter_code = "0100"
    zeroed_heading_code = "010000"
    SectionQuery.new.code(section_code).first.description.should eq "LIVE ANIMALS"
    ChapterQuery.new.code(zeroed_chapter_code).first?.should_not be nil
    HeadingQuery.new.code(zeroed_heading_code).first?.should_not be nil

    # Same for the first chapter
    chapter_desc = "Live horses, asses, mules and hinnies."
    zeroed_heading_code = "010100"
    ChapterQuery.new.code("0101").first.description.should eq chapter_desc
    HeadingQuery.new.code(zeroed_heading_code).first?.should_not be nil


    # And lastly, we make sure our heading is imported
    heading_desc = "(2002-2011) - Pure-bred breeding animals"
    HeadingQuery.new.code("010110").first.description.should eq heading_desc
  end
end
