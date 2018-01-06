require "csv"
require "../spec_helper.cr"
require "../../src/lib/import_record_importer.cr"
require "./test_data.cr"

# Imports
def build_import_csvs(hscode, origin, consignment)
  pre_2007 = CSV.build do |csv|
    csv.row "Year", "HS Code", "HS Description", "Country (Origin)", "Country (Consignment)", "Quantity", "Unit", "Net Mass (Kg)", "CIF Value (ETB)", "CIF Value (USD)"
    csv.row "1997", hscode.code, hscode.description, origin.name, consignment.name, "", "", "327652459", "370630566.4", "55220740.55"
  end

  post_2007 = CSV.build do |csv|
    csv.row "Year", "Month", "CPC", "HS Code", "HS Description", "Country (Origin)", "Country (Consignment)", "Quantity", "Unit", "Gross Wt. (Kg)", "Net Wt. (Kg)", "CIF Value (ETB)", "CIF Value (USD)", "Total tax (ETB)", "Total tax (USD)"
    csv.row "2007", "1", "4000 403", hscode.code, hscode.description, origin.name, consignment.name, "", "LTR", "102680260", "102680260", "520396079.74", "57516946.8196337", "0", "0"
  end

  post_2017 = CSV.build do |csv|
    csv.row "Year", "Month", "CPC", "HS Code", "HS Description", "Country (Origin)", "Country (Consignment)", "Quantity", "Sup. Unit", "Gross Wt. (Kg)", "Net Wt. (Kg)", "CIF Value (ETB)", "CIF Value (USD)", "Total tax (ETB)", "Total tax (USD)"
    csv.row "2017", "1", "4000 421", hscode.code, hscode.description, origin.name, consignment.name, "", "", "66210760", "66000000", "983769468.1", "41698928.8027399", "0", "0"
  end

  [pre_2007, post_2007, post_2017]
end

# There are three "types" of records. Pre 2007, 2007 - 2016 and >= 2017.
# The first group doesn't record months and has slight differences in
# labels. The last two groups only differ in label names.
#
# We're going to test to make sure that the importer class can handle all
# three types.
describe ImportRecordImporter do
  Spec.before_each do
    import_test_hscodes
    import_test_countries
  end

  context "with csvs" do
    it "imports pre_2007 exports" do
      hscode = HscodeQuery.new.first
      origin = CountryQuery.new.find(1)
      consignment = CountryQuery.new.find(2)
      pre_2007, post_2007, post_2017 = build_import_csvs(hscode, origin, consignment)

      it "does stuff" do
        parsed = CSV.parse(pre_2007)
        year = parsed[1].first
        csv = CSV.new(pre_2007, headers: true)
        ImportRecordImporter.new(csv, parsed.size, year.to_i, false).call
      end

      it "imports post_2007 exports" do
        parsed = CSV.parse(post_2007)
        year = parsed[1].first
        csv = CSV.new(post_2007, headers: true)
        ImportRecordImporter.new(csv, parsed.size, year.to_i, false).call
      end

      it "imports post_2017 exports" do
        parsed = CSV.parse(post_2017)
        year = parsed[1].first
        csv = CSV.new(post_2017, headers: true)
        ImportRecordImporter.new(csv, parsed.size, year.to_i, false).call
      end
    end
  end
end
