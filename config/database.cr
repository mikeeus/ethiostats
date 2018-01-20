database = "ethiostats_#{Lucky::Env.name}"

LuckyRecord::Repo.configure do
  settings.url = LuckyRecord::PostgresURL.build(
    hostname: "localhost",
    database: database
  )
end

LuckyMigrator::Runner.configure do
  settings.database = database
end
