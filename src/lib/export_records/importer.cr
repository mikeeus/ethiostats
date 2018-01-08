require "csv"
require "../import_progress_helpers.cr"
require "../record_importer_helpers.cr"
require "./header_builder.cr"
require "./params_helpers.cr"

class ExportRecords::Importer
  include ImportProgressHelpers
  include RecordImporterHelpers
  include ExportRecords::ParamsHelpers

  @headers = {} of String => String
  @errors = [] of NamedTuple(msg: String, row: CSV)

  def initialize(@csv : CSV, @length : Int32, @year : Int32, @show_progress = true)
    @headers = ExportRecords::HeaderBuilder.new(@year).build
  end

  def call
    @csv.each do |row|
      import_row row
      increment_progress
    end

    write_out_errors
  end

  private def import_row(row)
    code = row[@headers["code"]]
    hscode = HscodeQuery.new.code(code).first? || \
      create_missing_hscode(row)
    if hscode.nil?
      add_error row, "Error: Hscode not found for code '#{code}'"
      return
    end

    destination_name = row[@headers["destination"]]
    destination = CountryQuery.new.find_by_name?(destination_name)
    if destination.nil?
      add_error row, "Error: Country not found with name '#{destination_name}'"
      return
    end

    hash = unique_hash(row, hscode, destination)
    if ExportQuery.new.find_by_hash?(hash)
      return
    end

    params = build_params(row, hscode, destination, hash)
    export = ExportForm.new(params)

    unless export.save
      pp params
      add_error row, "Error importing export record: #{export.errors.inspect}."
    end
  end

  private def export_exists?(row, hscode, destination)
    hash = unique_hash(row, hscode, destination)
    ExportQuery.new.unique_hash(hash).first?
  end

  private def unique_hash(row, hscode, destination)
    if @headers["month"]?
      month = row[@headers["month"]]
    else
      month = nil
    end

    if @headers["cpc"]?
      cpc = row[@headers["cpc"]]
    else
      cpc = nil
    end
    fob_etb = row[@headers["fob_etb"]]
    fob_usd = row[@headers["fob_usd"]]

    Export.build_hash(hscode.id.to_s, @year.to_s, month, cpc, destination.id.to_s, fob_etb, fob_usd)
  end
end
