class CreateExports::V20180104171700 < LuckyMigrator::Migration::V1
  def migrate
    create :exports do
      belongs_to Hscode, on_delete: :cascade
      belongs_to Destination, references: :countries, on_delete: :cascade

      add year : Int32
      add month : Int32?
      add cpc : String?
      add quantity : Int32?

      add mass_gross_kg : Int32?
      add mass_net_kg : Int32
      add fob_etb_cents : Int32
      add fob_usd_cents : Int32
      add tax_etb_cents : Int32?
      add tax_usd_cents : Int32?
    end

    execute "CREATE INDEX ON exports (year, month);"
    execute "CREATE INDEX ON exports (hscode_id, year, month);"
    execute "CREATE UNIQUE INDEX unique_export_index
            ON exports (hscode_id, year, month, cpc,
                        destination_id,
                        fob_etb_cents, fob_usd_cents)"
  end

  def rollback
    drop :exports
  end
end
