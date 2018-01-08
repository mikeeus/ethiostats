require "../record_importer_helpers.cr"

module ExportRecords::ParamsHelpers
  private def build_params(row, hscode, destination, hash)
    params = default_params(row, hscode, destination, hash)
    if @year > 2007
      params.merge!(post_2007_params(row))
    else
      params
    end
  end

  private def default_params(row, hscode, destination, hash)
    {
      "hscode_id" => hscode.id.to_s,
      "destination_id" => destination.id.to_s,
      "year" => @year.to_s,
      "code" => row[@headers["code"]],
      "description" => row[@headers["description"]],
      "quantity" => ensure_int_with_default(row[@headers["quantity"]], "-1"),
      "unit" => row[@headers["unit"]],
      "mass_net_kg" => to_cents(row[@headers["mass_net"]]),
      "fob_etb_cents" => to_cents(row[@headers["fob_etb"]]),
      "fob_usd_cents" => to_cents(row[@headers["fob_usd"]]),
      "unique_hash" => hash
    }
  end

  private def post_2007_params(row)
    {
      "month" => row[@headers["month"]],
      "mass_gross_kg" => to_cents(row[@headers["mass_gross"]]),
      "tax_etb_cents" => to_cents(row[@headers["tax_etb"]]),
      "tax_usd_cents" => to_cents(row[@headers["tax_usd"]]),
    }
  end
end