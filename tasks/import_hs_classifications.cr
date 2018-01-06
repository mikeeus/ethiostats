# require CSV
require "csv"
require "../src/lib/hs_classification_importer.cr"

class ImportHsClassifications < LuckyCli::Task
  # banner that shows up when we list tasks with `lucky --help`
  banner "Import hscodes from a csv file"

  def call
    import_hs_classifications
  end

  def import_hs_classifications
    puts "Importing HS classifications"

    file_path = "static/records/csv/hs_classification.csv"

    # Get csv length for progress bar
    length = get_csv_length(file_path)

    File.open(file_path) do |f|
      # Instantiate CSV
      csv = CSV.new(f, headers: true)

      HsClassificationImporter.new(csv: csv, length: length).call
    end
  end

  private def get_csv_length(file_path)
    File.open(file_path) do |f|
      CSV.parse(f).size
    end
  end
end
