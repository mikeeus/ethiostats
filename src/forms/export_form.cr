class ExportForm < Export::BaseForm
  allow hscode_id
  allow destination_id

  allow year
  allow month
  allow cpc
  allow quantity

  allow mass_gross_kg
  allow mass_net_kg
  allow fob_etb_cents
  allow fob_usd_cents
  allow tax_etb_cents
  allow tax_usd_cents

  allow unique_hash

  def before_save
    set_hash
  end

  def set_hash
    unique_hash.value = Export.build_hash(hscode_id, year, month, cpc, destination_id, fob_etb_cents, fob_usd_cents)
  end

  def prepare
    validate_required hscode_id
    validate_required destination_id

    validate_required year
    validate_required mass_net_kg
    validate_required fob_etb_cents
    validate_required fob_usd_cents

    validate_required unique_hash
  end
end