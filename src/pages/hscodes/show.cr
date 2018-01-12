class Hscodes::ShowPage < MainLayout
  include Charts::Components
  needs hscode : Hscode

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
          hscode_annual_totals_chart(@hscode.id)
        end
      end
      div class: "hscodes-row-3" do
        related_hscodes
      end

      # TASK: Troubleshoot ajax data loading, or use a different tables lib
      # div class: "hscodes-row-3" do
      #   div class: "imports-table" do
      #     h3 "Imports"
      #     imports_table
      #   end

      #   div class: "exports-table" do
      #     h3 "Exports"
      #     exports_table
      #   end
      # end
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
    table id: "hscode-imports-table", class: "table" do
      thead do
        tr do
          th "Year"
          th "Country"
          th "Total Value (USD)"
        end
      end
      tbody do
        @hscode.imports_by_year.each do |row|
          tr do
            td row.year
            td row.country
            td (row.total / 100.0).to_s
          end
        end
      end
    end
    div id: "imports-table-paging"

    script do
      raw %(
        var hscodeImportsDatatable = new DataTable(document.querySelector('#hscode-imports-table'), {
          pageSize: 10,
          sort: [true, true, true],
          filters: ['select', false, false],
          filterText: 'Type to filter... ',
          pagingDivSelector: "#imports-table-paging",
          // data: {
          //   url: "/hscodes/tables",
          //   type: "get",
          //   size: 157,
          //   allInOne: false,
          //   refresh: false
          // }
        });
      )
    end
  end

  private def exports_table
    table id: "hscode-exports-table", class: "table" do
      thead do
        tr do
          th "Year"
          th "Country"
          th "Total Value (USD)"
        end
      end
      tbody do
        @hscode.exports_by_year.each do |row|
          tr do
            td row.year
            td row.country
            td (row.total / 100.0).to_s
          end
        end
      end
    end
    div id: "exports-table-paging"

    script do
      raw %(
        var hscodeExportsDatatable = new DataTable(document.querySelector('#hscode-exports-table'), {
          pageSize: 10,
          sort: [true, true, true],
          filters: ['select', false, false],
          filterText: 'Type to filter... ',
          pagingDivSelector: "#exports-table-paging",
          // data: {
          //   url: "/hscodes/tables",
          //   type: "get",
          //   size: 157,
          //   allInOne: false,
          //   refresh: false
          // }
        });
      )
    end
  end
end
