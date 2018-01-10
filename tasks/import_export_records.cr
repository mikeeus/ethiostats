require "./import_task_helpers.cr"
require "../src/lib/export_records/importer.cr"

class ImportExportRecords < LuckyCli::Task
  include ImportTaskHelpers
  @records : Array(String) = Dir.new(@csv_exports_path).children

  # banner that shows up when we list tasks with `lucky --help`
  banner "Import export records"

  def call
    ensure_ready_to_import_records

    years = ARGV.map(&.to_i)
    if years.empty?
      import_records(nil)
    else
      years.each do |year|
        import_records(year)
      end
    end

  end

  private def import_records(year :  Int32?)
    if year
      puts "Importing import records for #{year}"
      filename = @records.select { |f| f.includes?(year.to_s) }.first
      file_path = "#{@csv_exports_path}/#{filename}"

      import_csv_file(file_path)
    else
      @records.sort.each do |filename|
        file_path = "#{@csv_exports_path}/#{filename}"
        import_csv_file(file_path)
      end
    end
  end

  private def import_csv_file(file_path)
    puts "importing #{file_path}"
    File.open(file_path) do |f|
      # Get csv length for progress bar
      length, year = csv_length_year(file_path)

      # Instantiate CSV
      csv = CSV.new(f, headers: true)
      ExportRecords::Importer.new(csv, length.to_i, year.to_i).call
    end
  end
end
