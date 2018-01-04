class CreateExtensions::V20180104171524 < LuckyMigrator::Migration::V1
  def migrate
    execute "CREATE extension IF NOT EXISTS btree_gist"
    execute "CREATE extension IF NOT EXISTS postgis"
    execute "CREATE extension IF NOT EXISTS pg_trgm"
  end

  def rollback
    execute "DROP extension IF NOT EXISTS pg_trgm"
    execute "DROP extension IF NOT EXISTS postgis"
    execute "DROP extension IF NOT EXISTS btree_gist"
  end
end
