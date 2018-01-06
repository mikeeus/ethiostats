require "csv"

module CSVImportHelpers
  private def get_csv_length(file_path)
    File.open(file_path) do |f|
      CSV.parse(f).size
    end
  end
end