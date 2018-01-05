require "progress"

# Imports Country models from a YAML array of country objects and an map of
# country aliases.
class CountryImporter
  def initialize(countries : Array(YAML::Any), aliases : YAML::Any, show_progress = true)
    @show_progress = show_progress
    @countries = countries
    @aliases = aliases
    @bar = ProgressBar.new
  end

  def call
    LuckyRecord::Repo.run do |db|
      @countries[0,25].each do |item|
        short, lat, lon, name = item.to_s.split("\t")

        if CountryQuery.new.name(name).first?
          increment_progress
          next
        end

        coordinates = "POINT (#{lon} #{lat})"

        sql = insert_country_sql(name, short, lon, lat)
        db.exec sql, name, short, coordinates
        increment_progress
      end
    end
  end

  private def increment_progress
    if @show_progress
      @bar.inc
    end
  end

  private def insert_country_sql(name : String, short : String, lon, lat)
    <<-SQL
    INSERT INTO countries
      (created_at, updated_at, name, short, coordinates, aliases)
      VALUES (NOW(), NOW(), $1, $2, $3, '{#{escaped_aliases(name)}}'::text[]);
    SQL
  end

  private def escaped_aliases(name)
    alias_arr = @aliases[name]? || [] of String

    alias_arr = alias_arr.map do |a|
      PG::EscapeHelper.escape_literal(a.to_s).lchop.rchop
    end

    alias_arr.join(',')
  end
end