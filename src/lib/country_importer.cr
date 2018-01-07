require "./import_progress_helpers.cr"

# Imports Country models from a YAML array of country objects and an map of
# country aliases.
class CountryImporter
  include ImportProgressHelpers
  @length = 0

  def initialize(@countries : Array(YAML::Any), @aliases : YAML::Any, @show_progress = true)
    @length = @countries.size
  end

  def call
    LuckyRecord::Repo.run do |db|
      @countries.each do |item|
        # A row is tab separated string of values
        # eg: KR	35.907757	127.766922	South Korea
        # So we split by "\t" to get an array of values and set our variables
        short, lat, lon, name = item.to_s.split("\t")

        # If the country already exists go to the next iteration
        existing = CountryQuery.new.name(name).first?
        if existing
          db.exec update_aliases(existing)
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

  private def update_aliases(existing : Country)
    <<-SQL
    UPDATE countries SET aliases = '{#{escaped_aliases(existing.name)}}'::text[] WHERE id = #{existing.id};
    SQL
  end

  # We escape any special characters in the aliases using PG::EscapeHelper.
  # This returns a string surrounded by single quotes so we remove those using
  # lchop and rchop.
  private def escaped_aliases(name)
    alias_arr = @aliases[name]? || [] of String

    alias_arr = alias_arr.map do |a|
      a.to_s.gsub("'", "''").gsub(",", "\\,")
    end

    alias_arr.join(',')
  end
end
