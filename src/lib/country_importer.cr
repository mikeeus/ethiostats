require "progress"

# Imports Country models from a YAML array of country objects and an map of
# country aliases.
class CountryImporter
  def initialize(countries : Array(YAML::Any), aliases : YAML::Any, show_progress = true)
    @show_progress = show_progress
    @countries = countries
    @aliases = aliases
    @bar = ProgressBar.new
    @bar.width = 40
  end

  def call
    LuckyRecord::Repo.run do |db|
      @countries.each do |item|
        # A row is tab separated string of values
        # eg: KR	35.907757	127.766922	South Korea
        # So we split by "\t" to get an array of values and set our variables
        short, lat, lon, name = item.to_s.split("\t")

        # If the country already exists go to the next iteration
        if CountryQuery.new.name(name).first?
          increment_progress
          next
        end

        # postgis sets coordinates using a string in the following form:
        coordinates = "POINT (#{lon} #{lat})"

        # Because Lucky doesn't support Postgresql arrays yet, we will build
        # build our sql statement manually
        sql = insert_country_sql(name, short, lon, lat)

        # and execute it
        db.exec sql, name, short, coordinates

        increment_progress
      end
    end
  end

  # Our sql statement
  private def insert_country_sql(name, short, lon, lat)
    <<-SQL
    INSERT INTO countries
      (created_at, updated_at, name, short, coordinates, aliases)
      VALUES (NOW(), NOW(), $1, $2, $3, '{#{escaped_aliases(name)}}'::text[]);
    SQL
  end

  # We escape any special characters in the aliases using PG::EscapeHelper.
  # This returns a string surrounded by single quotes so we remove those using
  # lchop and rchop.
  private def escaped_aliases(name)
    alias_arr = @aliases[name]? || [] of String

    alias_arr = alias_arr.map do |a|
      PG::EscapeHelper.escape_literal(a.to_s).lchop.rchop
    end

    alias_arr.join(',')
  end

  # Only increment the progress bar if the @show_progress is true
  private def increment_progress
    if @show_progress
      @bar.inc
    end
  end
end
