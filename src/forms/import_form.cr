require "base64"

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

  allow unique_hash

  def before_save
    set_hash
  end

  def set_hash
    unique_hash.value = Import.build_hash(hscode_id, year, month, cpc, origin_id, consignment_id, cif_etb_cents, cif_usd_cents)
  end

  def prepare
    validate_required hscode_id
    validate_required origin_id
    validate_required consignment_id

    validate_required year
    validate_required mass_net_kg
    validate_required cif_etb_cents
    validate_required cif_usd_cents

    validate_required unique_hash
  end
end
