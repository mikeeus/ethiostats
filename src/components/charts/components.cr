module Charts::Components
  private def c3_scripts_and_css
    css_link asset("css/c3.min.css")
    js_link asset("js/c3.min.js")
    js_link asset("js/d3.v3.min.js")
  end

  private def hscode_annual_totals_chart(id)
    h2 "Total Imports and Exports Since 1997"
    div id: "hscode-chart"

    c3_chart("#hscode-chart", **get_chart_data(:hscode, id))
  end

  private def homepage_chart
    h2 "Annual Imports and Exports Since 1997"
    div id: "homepage-chart"

    c3_chart("#homepage-chart", **get_chart_data(:homepage))
  end

  private def get_chart_data(page = :homepage, id = nil)
    if page == :homepage
      annual_totals = ChartQuery.annual_totals
    elsif page == :hscode
      if id.nil?
        raise "must pass in 'id' to get hscode chart data"
      end
      annual_totals = ChartQuery.hscode_annual_totals(id)
    else
      raise "get_chart_data expects :homepage or :hscode, but :#{page} was given."
    end

    imports = ["Imports"] + annual_totals.map{ |a| (a.imports_total / 100_000_000).to_s }
    exports = ["Exports"] + annual_totals.map{ |a| (a.exports_total / 100_000_000).to_s }
    years = ["year"] + annual_totals.map(&.year)

    { years: years, imports: imports, exports: exports }
  end

  private def c3_chart(selector, years, imports, exports)
    script do
      raw %(
        var chart = c3.generate({
          bindto: '#{selector}',
          data: {
            x: 'year',
            columns: [
              #{years},
              #{imports},
              #{exports}
            ],
            types: {
              Imports: 'bar',
              Exports: 'bar'
            },
            colors: {
              Imports: '#ff9800',
              Exports: '#9fed4d'
            },
          },
          // regions: [
          //   { start: 1997, end: 2007, class: "c3-region-lt2007" },
          //   { start: 2007, class: "c3-region-gte2007" },
          // ],
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