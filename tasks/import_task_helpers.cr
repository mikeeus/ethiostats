require "csv"

module ImportTaskHelpers
  private def get_csv_length(file_path)
    File.open(file_path) do |f|
      CSV.parse(f).size
    end
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
    ensure_countries_are_imported
    ensure_hs_classifications_are_imported
    ensure_hscodes_are_imported
  end
end