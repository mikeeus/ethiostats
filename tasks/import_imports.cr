require "./import_task_helpers.cr"
require "../src/lib/import_records/importer.cr"

class ImportImports < LuckyCli::Task
  include ImportTaskHelpers

  # banner that shows up when we list tasks with `lucky --help`
  banner "Import hscodes from a csv file"

  def call
    ensure_ready_to_import_records
    import_imports
  end

  private def import_imports
    puts "Importing import records"

    csv_imports_path = "static/records/csv/imports"

    file_names = Dir.new(csv_imports_path).children.sort

    file_names.each do |filename|
      file_path = "#{csv_imports_path}/#{filename}"
      puts "importing #{file_path}"
      File.open(file_path) do |f|
        # Get csv length for progress bar
        length, year = csv_length_year(file_path)

        # Instantiate CSV
        csv = CSV.new(f, headers: true)
        ImportRecords::Importer.new(csv, length.to_i, year.to_i).call
      end
    end
  end
end
