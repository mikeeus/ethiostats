class ChartQuery
  def self.annual_totals
    statement = <<-SQL
      SELECT i.year, i.total as imports_total, e.total as exports_total
      FROM (
        SELECT year, sum(cif_usd_cents) as total
        FROM imports
        GROUP BY year
        ORDER BY year
      ) i
      INNER JOIN (
        SELECT year, sum(fob_usd_cents) as total
        FROM exports
        GROUP BY year
        ORDER BY year
      ) e
      ON i.year = e.year;
    SQL

    annual_imports = LuckyRecord::Repo.run do |db|
      db.query_all statement, as: AnnualTotals
    end
  end
end

class AnnualTotals
  DB.mapping({
    year: Int32,
    imports_total: Int64,
    exports_total: Int64
  })
end