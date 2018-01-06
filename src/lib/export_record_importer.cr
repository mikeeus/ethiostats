require "csv"
require "./import_progress_helpers.cr"
require "./record_importer_helpers.cr"

class ExportRecordImporter
  include ImportProgressHelpers
  include RecordImporterHelpers

  @labels = {} of String => String

  @errors = [] of NamedTuple(msg: String, row: CSV)

  def initialize(@csv : CSV, @length : Int32, @year : Int32, @show_progress = true)
    @labels = labels_for @year
  end

  def call
    @csv.each do |row|
      import_row row
      increment_progress
    end

    write_out_errors
  end

  private def import_row(row)
    if @year < 2007
      export = ExportForm.new(default_params(row))
    else @year > 2007 && @year < 2017
      export = ExportForm.new(
        default_params(row).merge!(
          {
            "month" => row[@labels["month"]],
            "mass_gross_kg" => to_cents(row[@labels["mass_gross"]]),
            "tax_etb_cents" => to_cents(row[@labels["tax_etb"]]),
            "tax_usd_cents" => to_cents(row[@labels["tax_usd"]]),
          }
        )
      )
    end

    unless export.save
      add_error row, "Error importing export record: #{export.errors.inspect}."
    end
  end

  private def default_params(row)
    if @default_params
      @default_params
    end

    code = row[@labels["code"]]
    destination_name = row[@labels["destination"]]

    hscode = HscodeQuery.new.code(code).first
    destination = CountryQuery.new.name(destination_name).first

    @default_params = {
      "hscode_id" => hscode.id.to_s,
      "destination_id" => destination.id.to_s,
      "year" => @year.to_s,
      "code" => code,
      "description" => row[@labels["description"]],
      "quantity" => ensure_int_with_default(row[@labels["quantity"]], "-1"),
      "unit" => row[@labels["unit"]],
      "mass_net_kg" => to_cents(row[@labels["mass_net"]]),
      "fob_etb_cents" => to_cents(row[@labels["fob_etb"]]),
      "fob_usd_cents" => to_cents(row[@labels["fob_usd"]]),
      "unique_hash" => "changed in before_save"
    }
  end

  private def labels_for(year)
    if year < 2007
      {
        "year" => "Year",
        "code" => "HS Code",
        "description" => "HS Description",
        "destination" => "Destination",
        "quantity" => "Quantity",
        "unit" => "Unit",
        "mass_net" => "Net Mass (Kg)",
        "fob_etb" => "FOB Value (ETB)",
        "fob_usd" => "FOB Value (USD)"
      }
    elsif year >= 2007 && year < 2017
      {
        "year" => "Year",
        "month" => "Month",
        "cpc" => "CPC",
        "code" => "HS Code",
        "description" => "HS Description",
        "destination" => "Destination",
        "quantity" => "Quantity",
        "unit" => "Unit",
        "mass_gross" => "Gross Wt. (Kg)",
        "mass_net" => "Net.Wt. (Kg)",
        "fob_etb" => "FOB Value (ETB)",
        "fob_usd" => "FOB Value (USD)",
        "tax_etb" => "Total tax (ETB)",
        "tax_usd" => "Total tax (USD)",
      }
    else
      {
        "year" => "Year",
        "month" => "Month",
        "cpc" => "CPC",
        "code" => "HS Code",
        "description" => "HS Description",
        "destination" => "Destination",
        "quantity" => "Quantity",
        "unit" => "Sup. Unit",
        "mass_gross" => "Gross Wt. (Kg)",
        "mass_net" => "Net.Wt. (Kg)",
        "fob_etb" => "FOB Value (ETB)",
        "fob_usd" => "FOB Value (USD)",
        "tax_etb" => "Total tax (ETB)",
        "tax_usd" => "Total tax (USD)",
      }
    end
  end

  private def export_exists?(hscode_id, year, month, cpc, destination_id, fob_etb, fob_usd)
    hash = Export.unique_hash(hscode_id, year, month, cpc, destination_id, fob_etb, fob_usd)
    ExportQuery.new.find_by_hash()
  end
end
