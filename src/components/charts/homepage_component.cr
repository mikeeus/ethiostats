module Charts::HomepageComponent
  private def homepage_chart
    h2 "Annual Imports and Exports Since 1997"
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

end