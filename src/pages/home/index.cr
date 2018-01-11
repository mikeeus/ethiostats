class Home::IndexPage < MainLayout
  def inner
    text "Homepage chart"
    homepage_chart
  end

  private def homepage_chart
    div id: "homepage-chart"

    annual_totals = ChartQuery.annual_totals
    imports = ["Imports"] + annual_totals.map{ |a| (a.imports_total / 100_000_000).to_s }
    exports = ["Exports"] + annual_totals.map{ |a| (a.exports_total / 100_000_000).to_s }
    years = ["year"] + annual_totals.map(&.year)

    script do
      raw %(
        var chart = c3.generate({
          bindto: '#homepage-chart',
          data: {
            x: 'year',
            columns: [
              #{years},
              #{imports},
              #{exports}
            ],
            // types: {
            //   Imports: 'bar',
            //   Exports: 'bar'
            // }
          },
          axis: {
            y: {
              label: {
                text: 'Millions',
                // position: 'outer-middle'
              },
              tick: {
                format: d3.format('$,')
              }
            }
          }
        });
      )
    end
  end

  private def import_columns
    ["Imports"] + total_dollars(annual_totals_by_year(:imports))
  end

  private def export_columns
    ["Exports"] + total_dollars(annual_totals_by_year(:exports))
  end

  private def total_dollars(value : Array(AnnualTotal))
    value.map { |i| (i.total / 100).to_s }
  end
end
