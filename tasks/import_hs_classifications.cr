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

    # Get csv length for progress bar
    length = csv_length(@csv_hs_class_path)

    File.open(@csv_hs_class_path) do |f|
      # Instantiate CSV
      csv = CSV.new(f, headers: true)

      HsClassificationImporter.new(csv: csv, length: length).call
    end
  end
end
