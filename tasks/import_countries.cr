require "yaml"
require "../src/lib/country_importer.cr"

class ImportCountries < LuckyCli::Task
  banner "Import countries from a yaml file"

  def call
    countries = nil
    aliases = nil
    errors = [] of Hash(Symbol, Array(String))

    File.open("static/assets/countries.yaml") do |f|
      parsed = YAML.parse(f)
      countries = parsed["countries"].to_a
      aliases = parsed["aliases"]
    end

    if countries.nil? || aliases.nil?
      puts "There was a problem parsing countries.yaml: countries object was nil."
    else
      CountryImporter.new(countries, aliases).call
    end
  end
end
