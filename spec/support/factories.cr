require "./test_data.cr"

# Seed test db for integration tests
def seed_test_db
  seed_countries
  seed_hs_classifications
  seed_hscodes

  import_import_records
  import_export_records
end

def seed_countries
  data = test_countries_yaml
  countries = data["countries"].to_a
  aliases = data["aliases"]
  CountryImporter.new(countries, aliases, show_progress: false).call
end

def seed_hs_classifications
  data = test_hs_classifications_csv

  length = CSV.parse(data).size
  HsClassificationImporter.new(CSV.new(data, headers: true), length, false).call
end

def seed_hscodes
  seed_hs_classifications

  data = test_hscodes_csv

  length = CSV.parse(data).size
  HscodeImporter.new(CSV.new(data, headers: true), length, false).call
end

def seed_import_records
  seed_hscodes
  seed_countries

  import_import_records
end

def seed_export_records
  seed_hscodes
  seed_countries
  import_export_records
end

private def import_import_records
  csv_strings = prepared_import_csvs
  csv_strings.each do |csv_string|
    import_csv_string(csv_string, :imports)
  end
end

private def import_export_records
  csv_strings = prepared_export_csvs
  csv_strings.each do |csv_string|
    import_csv_string(csv_string, :exports)
  end
end

private def import_csv_string(csv_string, record_type = :imports)
  parsed = CSV.parse(csv_string)
  year = parsed[1].first
  csv = CSV.new(csv_string, headers: true)
  if record_type == :imports
    ImportRecords::Importer.new(csv, parsed.size, year.to_i, false).call
  else
    ExportRecords::Importer.new(csv, parsed.size, year.to_i, false).call
  end
end

private def prepared_import_csvs
  hscode = HscodeQuery.new.first
  origin = CountryQuery.new.find(1)
  consignment = CountryQuery.new.find(2)
  import_record_csvs(hscode, origin, consignment)
end

private def prepared_export_csvs
  hscode = HscodeQuery.new.first
  destination = CountryQuery.new.find(1)
  export_record_csvs(hscode, destination)
end