class Hscodes::ShowPage < MainLayout
  needs hscode : Hscode

  def inner_head
    js_link asset("js/datatable.min.js")
    css_link asset("css/datatable.min.css")
  end

  def inner
    div class: "hscodes-wrapper" do
      div class: "hscodes-row-1" do
        div class: "hscodes-code" do
          div class: "code" do
            text @hscode.code
          end
          h3 @hscode.description
        end
        tax_rates
      end
      div class: "hscodes-row-2" do
        div class: "hscodes-chart" do
          text "Chart"
        end

        related_hscodes
      end

      div class: "hscodes-row-3" do
        div class: "imports-table" do
          h3 "Imports"
          imports_table
        end

        div class: "exports-table" do
          h3 "Exports"
          exports_table
        end
      end
    end
  end

  private def related_hscodes
    div class: "hscodes-related" do
      h3 "Related"
      @hscode.related.each do |related|
        link to: Hscodes::Show.path(related.code), class: "related-hscode" do
          text related.description
        end
      end
    end
  end

  private def tax_rates
    div class: "hscodes-rates" do
      div class: "rates" do
        div do
          text "Duty"
          span @hscode.duty.to_s + " %"
        end
        div do
          text "Excise"
          span @hscode.excise.to_s + " %"
        end
        div do
          text "VAT"
          span @hscode.vat.to_s + " %"
        end
        div do
          text "Sur"
          span @hscode.sur.to_s + " %"
        end
        div do
          text "Withholding"
          span @hscode.withholding.to_s + " %"
        end
        div do
          text "Export duty"
          span @hscode.export_duty.to_s + " %"
        end
      end
    end
  end

  private def imports_table
    imports = LuckyRecord::Repo.run do |db|
      db.query_all <<-SQL
        SELECT imports.year, countries.name as country, sum(cif_usd_cents)::bigint as total
        FROM imports
        JOIN countries
        ON countries.id = imports.origin_id
        WHERE imports.hscode_id = #{@hscode.id}
        GROUP BY imports.year, country
        ORDER BY year DESC, total DESC;
      SQL, as: TableRow
    end

    table class: "table table-bordered" do
      thead do
        tr do
          th "Year"
          th "Country"
          th "Total Value (USD)"
        end
      end
      tbody do
        imports.each do |row|
          tr do
            td row.year
            td row.country
            td (row.total / 100.0).to_s
          end
        end
      end
    end
  end

  private def exports_table
    exports = LuckyRecord::Repo.run do |db|
      db.query_all <<-SQL
        SELECT exports.year, countries.name as country, sum(fob_usd_cents)::bigint as total
        FROM exports
        JOIN countries
        ON countries.id = exports.destination_id
        WHERE exports.hscode_id = #{@hscode.id}
        GROUP BY exports.year, country
        ORDER BY year DESC, total DESC;
      SQL, as: TableRow
    end

    table class: "table table-bordered" do
      thead do
        tr do
          th "Year"
          th "Country"
          th "Total Value (USD)"
        end
      end
      tbody do
        exports.each do |row|
          tr do
            td row.year
            td row.country
            td (row.total / 100.0).to_s
          end
        end
      end
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