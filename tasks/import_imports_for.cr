require "./import_task_helpers.cr"
require "../src/lib/import_records/importer.cr"

class ImportImportsFor < LuckyCli::Task
  include ImportTaskHelpers
  @csv_imports_path = "static/records/csv/imports"
  @import_records : Array(String) = Dir.new(@csv_imports_path).children


  # banner that shows up when we list tasks with `lucky --help`
  banner "Import import records for the given years. Usage: import_imports_for 1997 2017"

  def call
    ensure_ready_to_import_records

    years = ARGV.map(&.to_i)
    if years.empty?
      puts "must provide at least one year"
      return
    end

    years.each do |year|
      import_records_for(year)
    end
  end

  private def import_records_for(year :  Int32)
    puts "Importing import records for #{year}"

    filename = @import_records.select { |f| f.includes?(year.to_s) }.first

    file_path = "#{@csv_imports_path}/#{filename}"
    puts "importing #{file_path}"
    File.open(file_path) do |f|
      # Get csv length for progress bar
      length = csv_length(file_path)

      # Instantiate CSV
      csv = CSV.new(f, headers: true)
      ImportRecords::Importer.new(csv, length.to_i, year).call
    end
  end
end
