# require "csv"
# require "../spec_helper.cr"
# require "./hscode_importer_spec.cr"
# require "../../src/lib/hs_classification_importer.cr"

# # Imports
# def build_import_csvs(hscode)
#   pre_2007_import = CSV.build do |csv|
#     csv.row "Year", "HS Code", "HS Description", "Country (Origin)", "Country (Consignment)", "Quantity", "Unit", "Net Mass (Kg)", "CIF Value (ETB)", "CIF Value (USD)"
#     csv.row "1997", hscode.code, hscode.description, "Saudi Arabia", "Saudi Arabia", "", "", "327652459", "370630566.4", "55220740.55"
#   end

#   post_2007_import = CSV.build do |csv|
#     csv.row "Year", "Month", "CPC", "HS Code", "HS Description", "Country (Origin)", "Country (Consignment)", "Quantity", "Unit", "Gross Wt. (Kg)", "Net Wt. (Kg)", "CIF Value (ETB)", "CIF Value (USD)", "Total tax (ETB)", "Total tax (USD)"
#     csv.row "2007", "1", "4000 403", hscode.code, hscode.description, "Saudi Arabia", "United Kingdom", "", "LTR", "102680260", "102680260", "520396079.74", "57516946.8196337", "0", "0"
#   end

#   post_2017_import = CSV.build do |csv|
#     csv.row "Year", "Month", "CPC", "HS Code", "HS Description", "Country (Origin)", "Country (Consignment)", "Quantity", "Sup. Unit", "Gross Wt. (Kg)", "Net Wt. (Kg)", "CIF Value (ETB)", "CIF Value (USD)", "Total tax (ETB)", "Total tax (USD)"
#     csv.row "2017", "1", "4000 421", hscode.code, hscode.description, "Brazil", "Brazil", "", "", "66210760", "66000000", "983769468.1", "41698928.8027399", "0", "0"
#   end
# end

# # There are three "types" of records. Pre 2007, 2007 - 2016 and >= 2017.
# # The first group doesn't record months and has slight differences in
# # labels. The last two groups only differ in label names.
# #
# # We're going to test to make sure that the importer class can handle all
# # three types.
# describe ImportRecordImporter do
#   Spec.before_each do
#     import_test_hscodes
#     hscode = HscodeQuery.new.first
#     build_import_csvs(hscode)
#   end

#   it "imports pre_2007 imports" do

#   end

#   it "imports post_2007 imports" do

#   end

#   it "imports post_2017 imports" do

#   end
# end
