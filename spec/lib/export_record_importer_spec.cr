require "csv"
require "../spec_helper.cr"
require "../../src/lib/hs_classification_importer.cr"

# Exports
def build_export_csvs(hscode)
  if hscode.nil?
    raise "export_record_importer_spec: Import test hscodes before running build_export_csvs"
  end

  pre_2007 = CSV.build do |csv|
    csv.row "Year", "HS Code", "HS Description", "Destination", "Quantity", "Unit", "Net Mass (Kg)", "FOB Value (ETB)", "FOB Value (USD)"
    csv.row "1997", hscode.code, hscode.description, "United Germany", "", "", "36179290", "759510942", "113160544.4"
  end

  post_2007 = CSV.build do |csv|
    csv.row "Year", "Month", "CPC", "HS Code", "HS Description", "Destination", "Quantity", "Unit", "Gross Wt. (Kg)", "Net.Wt. (Kg)", "FOB Value (ETB)", "FOB Value (USD)", "Total tax (ETB)", "Total tax (USD)"
    csv.row "2007", "1", "1071 100", hscode.code, hscode.description, "Portugal", "", "", "22226480", "22160000", "127971806.97", "14144125.7966113", "0", "0"
  end

  post_2017 = CSV.build do |csv|
    csv.row "Year", "Month", "CPC", "HS Code", "HS Description", "Destination", "Quantity", "Sup. Unit", "Gross Wt. (Kg)", "Net.Wt. (Kg)", "FOB Value (ETB)", "FOB Value (USD)", "Total tax (ETB)", "Total tax (USD)"
    csv.row "2017", "1", "1071 100", hscode.code, hscode.description, "Somalia", "", "", "3723460", "3237223", "366189819.81", "15521647.8247048", "0", "0"
  end

  [pre_2007, post_2007, post_2017]
end

# There are three "types" of records. Pre 2007, 2007 - 2016 and >= 2017.
# The first group doesn't record months and has slight differences in
# labels. The last two groups only differ in label names.
#
# We're going to test to make sure that the importer class can handle all
# three types.
describe ExportRecordImporter do
  Spec.before_each do
    import_test_hscodes
  end

  context "with csvs" do
    it "imports pre_2007 exports" do
      hscode = HscodeQuery.new.first
      pre_2007, post_2007, post_2017 = build_export_csvs(hscode)

      it "does stuff" do
        ExportRecordImporter.new(pre_2007, 1, false)
      end

      it "imports post_2007 exports" do
        ExportRecordImporter.new(post_2007, 1, false)
      end

      it "imports post_2017 exports" do
        ExportRecordImporter.new(post_2017, 1, false)
      end
    end

  end
end
