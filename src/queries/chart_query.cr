class ChartQuery
  def self.annual_totals(imports_where_clause = nil, exports_where_clause = nil)
    statement = <<-SQL
      SELECT i.year, i.total as imports_total, e.total as exports_total
      FROM (
        SELECT year, sum(cif_usd_cents)::bigint as total
        FROM imports
        #{imports_where_clause}
        GROUP BY year
        ORDER BY year
      ) i
      INNER JOIN (
        SELECT year, sum(fob_usd_cents)::bigint as total
        FROM exports
        #{exports_where_clause}
        GROUP BY year
        ORDER BY year
      ) e
      ON i.year = e.year;
    SQL

    annual_imports = LuckyRecord::Repo.run do |db|
      db.query_all statement, as: AnnualTotals
    end
  end

  def self.hscode_annual_totals(id)
    self.annual_totals("WHERE imports.hscode_id = #{id}", "WHERE exports.hscode_id = #{id}")
  end
end

class AnnualTotals
  DB.mapping({
    year: Int32,
    imports_total: Int64,
    exports_total: Int64
  })
end