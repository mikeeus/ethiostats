require "csv"

module ImportTaskHelpers
  @yaml_countries_path = "records/countries.yaml"
  @csv_hs_class_path = "records/csv/hs_classification.csv"
  @csv_tariffs_path = "records/csv/tariffs.csv"
  @csv_imports_path = "records/csv/imports"
  @csv_exports_path = "records/csv/exports"

  private def csv_length(file_path)
    length = 0
    File.open(file_path) do |f|
      csv = CSV.parse(f)
      length = csv.size
      csv = nil
    end
    length
  end

  private def csv_length_year(path)
    File.open(path) do |file|
      csv = CSV.parse(file)
      year = csv[1].first
      [csv.size, year]
    end
  end

  private def ensure_countries_are_imported
    puts "Checking countries."
    if CountryQuery.new.count < 96
      ImportCountries.new.call
    end
    puts "Ready."
  end

  private def ensure_hs_classifications_are_imported
    puts "Checking HS Classifications."
    if SectionQuery.new.count < 96 || ChapterQuery.new.count < 1354 || \
      HeadingQuery.new.count < 7293
      ImportHsClassifications.new.call
    end
    puts "Ready."
  end

  private def ensure_hscodes_are_imported
    puts "Checking Hscodes."
    if HscodeQuery.new.count < 6503
      ImportHscodes.new.call
    else
      puts "Ready."
    end
  end

  private def ensure_ready_to_import_records
    ensure_hscodes_are_imported
  end
end