class CreateImports::V20180104171644 < LuckyMigrator::Migration::V1
  def migrate
    create :imports do
      belongs_to Hscode, on_delete: :cascade
      belongs_to Origin, references: :countries, on_delete: :cascade
      belongs_to Consignment, references: :countries, on_delete: :cascade

      add year : Int64
      add month : Int64?
      add cpc : String?
      add quantity : Int64?

      add mass_gross_kg : Int64?
      add mass_net_kg : Int64
      add cif_etb_cents : Int64
      add cif_usd_cents : Int64
      add tax_etb_cents : Int64?
      add tax_usd_cents : Int64?
    end

    execute "CREATE INDEX ON imports (year, month);"
    execute "CREATE INDEX ON imports (hscode_id, year, month);"
    execute "CREATE UNIQUE INDEX unique_import_index
            ON imports (hscode_id, year, month, cpc,
                        origin_id, consignment_id,
                        cif_etb_cents, cif_usd_cents)"
  end

  def rollback
    drop :imports
  end
end
