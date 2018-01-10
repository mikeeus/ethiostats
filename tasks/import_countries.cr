# require YAML and our CountryImporter class
require "yaml"
require "../src/lib/country_importer.cr"
require "./import_task_helpers.cr"

class ImportCountries < LuckyCli::Task
  include ImportTaskHelpers

  # banner that shows up when we list tasks with `lucky --help`
  banner "Import countries from a yaml file"

  def call
    # Initialize our variables
    countries = nil
    aliases = nil

    # Open our file and parse it just like in the specs
    File.open(@yaml_countries_path) do |f|
      parsed = YAML.parse(f)
      countries = parsed["countries"].to_a
      aliases = parsed["aliases"]
    end

    # Make sure countries and aliases are valid.
    if countries.nil? || aliases.nil?
      puts "There was a problem parsing countries.yaml: countries object was nil."
    else
      # Import countries!
      CountryImporter.new(countries, aliases).call
    end
  end
end
