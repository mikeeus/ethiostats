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

    # puts "aliases: #{aliases}"

    if countries.nil? || aliases.nil?
      puts "There was a problem parsing countries.yaml: countries object was nil."
    else
      CountryImporter.new(countries, aliases).call
    end
  end
end

# require 'progress_bar'

# desc 'Import  list of countries and their aliases.'
# task import_countries: :environment do
#   @print_s = false

#   @logs = {
#     source: 'TASK: import_countries',
#     time: Time.current.iso8601,
#     filepath: '',
#     errors: []
#   }

#   # Get country names and aliases from json files
#   records = "#{Rails.root}/db/records"
#   country_names = JSON.parse(File.read("#{records}/country_names.json"))
#   country_aliases = JSON.parse(File.read("#{records}/country_aliases.json"))

#   @bar = ProgressBar.new(country_names.length)

#   ActiveRecord::Base.transaction do
#     # iterate over country_names list,
#     country_names.each do |name|
#       # check for existing country with that name
#       existing = Country.find_with_aliases(name)
#       # if it doesn't exist, create using its aliases from the aliases hash
#       if existing.nil?
#         country = Country.new(
#           name: name,
#           aliases: country_aliases["#{name}"] || []
#         )

#         unless country.save
#           @logs[:errors].push({ type: 'saveFailed', content: country.errors })
#         end
#       end
#       @bar.increment!
#     end #country_names.each
#   end # transaction

#   log_import_errors(@logs)
# end # task

# # Write errors out to errors file
# def log_import_errors(log)
#   return if log[:errors].empty?
#   File.write("./lib/tasks/import_errors/#{log[:time]}_exports.json",
#              JSON.pretty_generate(log))
# end