require "csv"
require "../spec_helper.cr"
require "../../src/lib/hscode_importer.cr"

# We can use CSV.build to easily create a CSV string
hs_class_data = CSV.build do |csv|
  csv.row "NomenclatureCode","Tier","ProductCode","Product Description"
  csv.row "HS","0"," Total","Total Trade"
  csv.row "HS","1","01","LIVE ANIMALS"
  csv.row "HS","2","0101","Live horses, asses, mules and hinnies."
  csv.row "HS","3","010110","(2002-2011) - Pure-bred breeding animals"
end

hs_code_data = CSV.build do |csv|
  csv.row "1", "1011000", "LIVE HORSES,ASSESS MULES,AND HINNIES:PURE-BRED BREEDING ANMALS", "UN", "MOA", "5", "0", "15", "10", "3", "0", "0", "0"
end

describe HscodeImporter do
  # We'll import the hs classes then the hscodes from our csv objects
  #  before each test
  Spec.before_each do
    hs_class_length = CSV.parse(data).size
    HsClassificationImporter.new(CSV.new(data, headers: true), hs_class_length, false).call

    length = CSV.parse(data).size
    HsCodeImporter.new(CSV.new(data, headers: true), length, false).call
  end

  # And clear the the table afterwards
  #
  # NOTE: deleting sections will destroy their chapters and headings and
  # hscodes because we set on_delete: :cascade when creating the associations
  Spec.after_each do
    LuckyRecord::Repo.run { |db| db.exec "DELETE FROM sections;" }
  end

  # NOTE: I include all the tests in a single bock to avoid multiple calls to
  # the db. There is no `Spec.before_all` method, so this will have to do for
  # now.
  it "imports hscode and sets section, chapter and heading" do
    hscode = HscodeQuery.new.first?
    hcsode.should_not be_nil

    # test associations
    hscode.section.code.should eq "01"
    hscode.chapter.code.should eq "0101"
    hscode.heading.code.should eq "010110"

    # make sure attrbutes are set
    hscode.withholding.should eq 3
    hscode.ss_1.should eq 3
  end
end
