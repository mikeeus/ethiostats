require "../record_importer_helpers.cr"

module ImportRecords::ParamsHelpers
  private def build_params(row, hscode, origin, consignment, hash)
    params = default_params(row, hscode, origin, consignment, hash)
    if @year > 2007
      params.merge!(post_2007_params(row))
    else
      params
    end
  end

  private def default_params(row, hscode, origin, consignment, hash)
    {
      "hscode_id" => hscode.id.to_s,
      "origin_id" => origin.id.to_s,
      "consignment_id" => consignment.id.to_s,
      "year" => @year.to_s,
      "code" => row[@headers["code"]],
      "description" => row[@headers["description"]],
      "quantity" => ensure_int_with_default(row[@headers["quantity"]], "-1"),
      "unit" => row[@headers["unit"]],
      "mass_net_kg" => to_cents(row[@headers["mass_net"]]),
      "cif_etb_cents" => to_cents(row[@headers["cif_etb"]]),
      "cif_usd_cents" => to_cents(row[@headers["cif_usd"]]),
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