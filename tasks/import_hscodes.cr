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

    # Get csv length for progress bar
    length = csv_length(@csv_tariffs_path)

    File.open(@csv_tariffs_path) do |f|
      # Instantiate CSV
      csv = CSV.new(f, headers: true)

      HscodeImporter.new(csv: csv, length: length).call
    end
  end
end
