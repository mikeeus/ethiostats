# An Export record
class Export < BaseModel
  table :exports do
    belongs_to hscode : Hscode
    belongs_to destination : Country

    field year : Int32
    field month : Int32?
    field cpc : String?
    field quantity : Int32?

    field mass_gross_kg : Int32?
    field mass_net_kg : Int32
    field fob_etb_cents : Int32
    field fob_usd_cents : Int32
    field tax_etb_cents : Int32?
    field tax_usd_cents : Int32?

    field unique_hash : String
  end

  def self.build_hash(hscode_id, year, month, cpc, destination_id, fob_etb, fob_usd)
    Base64.encode("#{hscode_id}|#{year}|#{month}|#{cpc}|#{destination_id}|#{fob_etb}|#{fob_usd}")
  end

  def build_hash
    Export.build_hash(hscode_id, year, month, cpc, destination_id, fob_etb, fob_usd)
  end
end
