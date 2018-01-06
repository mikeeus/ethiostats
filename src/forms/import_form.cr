class ImportForm < Import::BaseForm
  allow hscode_id
  allow origin_id
  allow consignment_id

  allow year
  allow month
  allow cpc
  allow quantity

  allow mass_gross_kg
  allow mass_net_kg
  allow cif_etb_cents
  allow cif_usd_cents
  allow tax_etb_cents
  allow tax_usd_cents

  allow hash

  def prepare
    validate_required hscode_id
    validate_required origin_id
    validate_required consignment_id

    validate_required year
    validate_required mass_net_kg
    validate_required cif_etb_cents
    validate_required cif_usd_cents

    validate_requried hash
  end
end
