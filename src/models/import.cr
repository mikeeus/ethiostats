# An Import record
class Import < BaseModel
  table :imports do
    belongs_to hscode : Hscode
    belongs_to origin : Country
    belongs_to consignment : Country

    field year : Int32
    field month : Int32?
    field cpc : String?
    field quantity : Int32?

    field mass_gross_kg : Int32?
    field mass_net_kg : Int32
    field cif_etb_cents : Int32
    field cif_usd_cents : Int32
    field tax_etb_cents : Int32?
    field tax_usd_cents : Int32?

    field hash : String
  end
end
