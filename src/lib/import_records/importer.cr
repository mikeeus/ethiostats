require "csv"
require "../import_progress_helpers.cr"
require "../record_importer_helpers.cr"
require "./header_builder.cr"
require "./params_helpers.cr"

class ImportRecords::Importer
  include ImportProgressHelpers
  include RecordImporterHelpers
  include ImportRecords::ParamsHelpers

  @headers = {} of String => String
  @errors = [] of NamedTuple(msg: String, row: CSV)

  def initialize(@csv : CSV, @length : Int32, @year : Int32, @show_progress = true)
    @headers = ImportRecords::HeaderBuilder.new(@year).build
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

    origin_name = row[@headers["origin"]]
    origin = CountryQuery.new.find_by_name?(origin_name)
    if origin.nil?
      add_error row, "Error: Origin country not found with name '#{origin_name}'"
      return
    end

    consignment_name = row[@headers["consignment"]]
    consignment = CountryQuery.new.find_by_name?(consignment_name)
    if consignment.nil?
      add_error row, "Error: Consignment country not found with name '#{consignment_name}'"
      return
    end

    hash = import_hash(row, hscode, origin, consignment)
    if ImportQuery.new.find_by_hash?(hash)
      return
    end

    params = build_params(row, hscode, origin, consignment, hash)
    import = ImportForm.new(params)

    unless import.save
      pp params
      add_error row, "Error importing import record: #{import.errors.inspect}."
    end
  end

  private def import_exists?(row, hscode, origin, consignment)
    hash = import_hash(row, hscode, origin, consignment)
    ImportQuery.new.unique_hash(hash).first?
  end

  private def import_hash(row, hscode, origin, consignment)
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
    cif_etb = row[@headers["cif_etb"]]
    cif_usd = row[@headers["cif_usd"]]

    Import.build_hash(hscode.id.to_s, @year.to_s, month, cpc, origin.id.to_s, consignment.id.to_s, cif_etb, cif_usd)
  end
end
