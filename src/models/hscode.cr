# Post models a blog article.
# A Harmonized System code that describes a class of products and
# it's tariff rates for Ethiopia
class Hscode < BaseModel
  table :hscodes do
    belongs_to section : Section
    belongs_to chapter : Chapter
    belongs_to heading : Heading

    field code : String
    field description : String
    field unit : String
    field special_permission : String?

    field duty : Int32
    field excise : Int32
    field vat : Int32
    field sur : Int32
    field withholding : Int32
    field ss_1 : Int32?
    field ss_2 : Int32?
    field export_duty : Int32?
  end

  # Returns hscodes that belongs the same HS chapter
  def related
    chapter.hscodes.reject { |hs| hs.id == id }
  end

  def exports_by_year(page = 1, page_length = 10)
    LuckyRecord::Repo.run do |db|
      db.query_all <<-SQL
        SELECT exports.year, countries.name as country, sum(fob_usd_cents)::bigint as total
        FROM exports
        JOIN countries
        ON countries.id = exports.destination_id
        JOIN hscodes ON hscodes.id = exports.hscode_id
        WHERE hscodes.code = $1
        GROUP BY exports.year, country
        ORDER BY year DESC, total DESC
        LIMIT #{page_length}
        OFFSET #{(page - 1) * page_length};
      SQL, code, as: TableRow
    end
  end

  def imports_by_year(page = 1, page_length = 10)
    LuckyRecord::Repo.run do |db|
      db.query_all <<-SQL
        SELECT imports.year, countries.name as country, sum(cif_usd_cents)::bigint as total
        FROM imports
        JOIN countries
        ON countries.id = imports.origin_id
        JOIN hscodes ON hscodes.id = imports.hscode_id
        WHERE hscodes.code = $1
        GROUP BY imports.year, country
        ORDER BY year DESC, total DESC
        LIMIT #{page_length}
        OFFSET #{(page - 1) * page_length};
      SQL, code, as: TableRow
    end
  end
end

class TableRow
  DB.mapping({
    year: Int32,
    country: String,
    total: Int64
  })
end