require "csv"
require "../spec_helper.cr"
require "../../src/lib/import_records/importer.cr"
require "../support/factories.cr"

# There are three "types" of records. Pre 2007, 2007 - 2016 and >= 2017.
# The first group doesn't record months and has slight differences in
# labels. The last two groups only differ in label names.
#
# We're going to test to make sure that the importer class can handle all
# three types.
describe ImportRecords::Importer do
  Spec.before_each do
    seed_import_records
  end

  context "with csvs" do
    it "imports pre_2007 exports" do
      it "imports pre_2007 import records" do
        ImportQuery.new.where(:year, 1997).count.should eq 1
      end

      it "imports post_2007 import records" do
        ImportQuery.new.where(:year, 2007).count.should eq 1
      end

      it "imports post_2017 import records" do
        ImportQuery.new.where(:year, 2017).count.should eq 1
      end
    end
  end
end
