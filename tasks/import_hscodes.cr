require "./import_task_helpers.cr"
require "../src/lib/hscode_importer.cr"

class ImportHscodes < LuckyCli::Task
  include ImportTaskHelpers

  # banner that shows up when we list tasks with `lucky --help`
  banner "Import hscodes from a csv file"

  def call
    ensure_hs_classifications_are_imported
    import_hscodes
  end

  private def import_hscodes
    puts "Importing Hscodes"

    file_path = "static/records/csv/tariffs.csv"

    # Get csv length for progress bar
    length = csv_length(file_path)

    File.open(file_path) do |f|
      # Instantiate CSV
      csv = CSV.new(f, headers: true)

      HscodeImporter.new(csv: csv, length: length).call
    end
  end
end
