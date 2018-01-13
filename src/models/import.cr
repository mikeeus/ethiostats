# An Import record
class Import < BaseModel
  table :imports do
    belongs_to hscode : Hscode
    belongs_to origin : Country
    belongs_to consignment : Country

    field year : Int32
    field month : Int32?
    field cpc : String?
    field quantity : Int64?

    field mass_gross_kg : Int64?
    field mass_net_kg : Int64
    field cif_etb_cents : Int64
    field cif_usd_cents : Int64
    field tax_etb_cents : Int64?
    field tax_usd_cents : Int64?

    field unique_hash : String
  end

  def self.build_hash(hscode_id, year, month, cpc, origin_id, consignment_id, cif_etb_cents, cif_usd_cents)
    Base64.encode("#{hscode_id}|#{year}|#{month}|#{cpc}|#{origin_id}|#{consignment_id}|#{cif_etb_cents}|#{cif_usd_cents}")
  end

  def build_hash
    Import.build_hash(hscode_id, year, month, cpc, origin_id, consignment_id, cif_etb_cents, cif_usd_cents)
  end
end
