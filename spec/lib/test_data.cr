# TEST DATA
# We'll use country data that contains our edge cases:
#   special characters
#   aliases
def import_test_countries
  data = YAML.parse <<-END
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

  # Get countries array and aliases object from data
  countries = data["countries"].to_a
  aliases = data["aliases"]
  # Import countries
  CountryImporter.new(countries, aliases, show_progress: false).call
end

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
