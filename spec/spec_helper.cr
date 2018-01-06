ENV["LUCKY_ENV"] = "test"
require "spec"
require "../src/app"
require "./support/**"
require "../src/lib/**"

Spec.after_each do
  truncate_database
end

def truncate_database
  LuckyRecord::Repo.truncate
end

# TEST DATA

# Import test hs classifications
def import_test_hs_classifications
  # We can use CSV.build to easily create a CSV string
  data = CSV.build do |csv|
    csv.row "NomenclatureCode","Tier","ProductCode","Product Description"
    csv.row "HS","0"," Total","Total Trade"
    csv.row "HS","1","01","LIVE ANIMALS"
    csv.row "HS","2","0101","Live horses, asses, mules and hinnies."
    csv.row "HS","3","010110","(2002-2011) - Pure-bred breeding animals"
  end

  length = CSV.parse(data).size
  HsClassificationImporter.new(CSV.new(data, headers: true), length, false).call
end

# Import test hs classifications then test hscodes
def import_test_hscodes
  import_test_hs_classifications

  data = CSV.build do |csv|
    csv.row "No.", "HS Code", "HS Description", "Suppl. Unit", "Special Permission", "Duty Tax Rate", "Excise Tax Rate", "VAT Rate", "Sur Tax Rate", "With Hold Rate", "Second Schedule 1", "Second Schedule 2", "Export Duty Tax Rate"
    csv.row "1", "1011000", "LIVE HORSES,ASSESS MULES,AND HINNIES:PURE-BRED BREEDING ANMALS", "UN", "MOA", "5", "0", "15", "10", "3", "0", "0", "0"
    csv.row "2", "1012000", "MISSING HEADING", "UN", "MOA", "5", "0", "15", "10", "3", "0", "0", "0"
    csv.row "3", "1011100", "SETS DEFAULTS", "", "MOA", "", "", "", "", "", "0", "0", "0"
  end

  length = CSV.parse(data).size
  HscodeImporter.new(CSV.new(data, headers: true), length, false).call
end