require "./import_task_helpers.cr"
require "../src/lib/hs_classification_importer.cr"

class ImportHsClassifications < LuckyCli::Task
  include ImportTaskHelpers

  # banner that shows up when we list tasks with `lucky --help`
  banner "Import hs classifications from a csv file"

  def call
    ensure_countries_are_imported
    import_hs_classifications
  end

  def import_hs_classifications
    puts "Importing HS classifications"

    file_path = "static/records/csv/hs_classification.csv"

    # Get csv length for progress bar
    length = csv_length(file_path)

    File.open(file_path) do |f|
      # Instantiate CSV
      csv = CSV.new(f, headers: true)

      HsClassificationImporter.new(csv: csv, length: length).call
    end
  end
end
