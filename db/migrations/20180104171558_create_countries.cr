class CreateCountries::V20180104171558 < LuckyMigrator::Migration::V1
  def migrate
    create :countries do
      add name : String
      add short : String
      add coordinates : String?
    end

    execute "ALTER TABLE countries ADD aliases text[] NOT NULL DEFAULT array[]::text[];"
  end

  def rollback
    drop :countries
  end
end
