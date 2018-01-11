# We'll use country data that contains our edge cases:
#   special characters
#   aliases
def test_countries_yaml
  # We can create a YAML object by parsing a string
  YAML.parse <<-END
  countries:
    - KR	35.907757	127.766922	South Korea
    - CI	7.539989	-5.54708	Côte d'Ivoire
    - FK	-51.796253	-59.523613	Falkland Islands [Islas Malvinas]
  aliases:
    South Korea:
      - Korea
      - Democratic People's Rep. of
      - Korea
      - Democratic People's Rep.
      - Korea Dem.People's Rep. Of
      - Korea
      - Dem.People's Rep. Of
      - Korea Democratic People&#39;s Rep. of
      - Korea  Dem.People&#39;s Rep. Of
      - Korea Democratic People's Rep.
      - Korea Republic Of
      - Korea Republic of
      -  Korea
      - Republic of
      - Korea  Republic Of
  END
end

def test_hs_classifications_csv
  # We can use CSV.build to easily create a CSV string
  CSV.build do |csv|
    csv.row "NomenclatureCode","Tier","ProductCode","Product Description"
    csv.row "HS","0"," Total","Total Trade"
    csv.row "HS","1","01","LIVE ANIMALS"
    csv.row "HS","2","0101","Live horses, asses, mules and hinnies."
    csv.row "HS","3","010110","(2002-2011) - Pure-bred breeding animals"
  end
end

def test_hscodes_csv
  CSV.build do |csv|
    csv.row "No.", "HS Code", "HS Description", "Suppl. Unit", "Special Permission", "Duty Tax Rate", "Excise Tax Rate", "VAT Rate", "Sur Tax Rate", "With Hold Rate", "Second Schedule 1", "Second Schedule 2", "Export Duty Tax Rate"
    csv.row "1", "1011000", "LIVE HORSES,ASSESS MULES,AND HINNIES:PURE-BRED BREEDING ANMALS", "UN", "MOA", "5", "0", "15", "10", "3", "0", "0", "0"
    csv.row "2", "1012000", "MISSING HEADING", "UN", "MOA", "5", "0", "15", "10", "3", "0", "0", "0"
    csv.row "3", "1011100", "SETS DEFAULTS", "", "MOA", "", "", "", "", "", "0", "0", "0"
  end
end

# Build CSV files for pre_2007, post_2007 and post_2017 import records
def import_record_csvs(hscode, origin, consignment)
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

# Build CSV files for pre_2007, post_2007 and post_2017 export records
def export_record_csvs(hscode, destination)
  pre_2007 = CSV.build do |csv|
    csv.row "Year", "HS Code", "HS Description", "Destination", "Quantity", "Unit", "Net Mass (Kg)", "FOB Value (ETB)", "FOB Value (USD)"
    csv.row "1997", hscode.code, hscode.description, destination.name, "", "", "36179290", "759510942", "113160544.4"
  end

  post_2007 = CSV.build do |csv|
    csv.row "Year", "Month", "CPC", "HS Code", "HS Description", "Destination", "Quantity", "Unit", "Gross Wt. (Kg)", "Net.Wt. (Kg)", "FOB Value (ETB)", "FOB Value (USD)", "Total tax (ETB)", "Total tax (USD)"
    csv.row "2007", "1", "1071 100", hscode.code, hscode.description, destination.name, "", "", "22226480", "22160000", "127971806.97", "14144125.7966113", "0", "0"
  end

  post_2017 = CSV.build do |csv|
    csv.row "Year", "Month", "CPC", "HS Code", "HS Description", "Destination", "Quantity", "Sup. Unit", "Gross Wt. (Kg)", "Net.Wt. (Kg)", "FOB Value (ETB)", "FOB Value (USD)", "Total tax (ETB)", "Total tax (USD)"
    csv.row "2017", "1", "1071 100", hscode.code, hscode.description, destination.name, "", "", "3723460", "3237223", "366189819.81", "15521647.8247048", "0", "0"
  end

  [pre_2007, post_2007, post_2017]
end