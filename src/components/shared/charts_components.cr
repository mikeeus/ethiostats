module Shared::ChartsComponents
  private def c3_scripts_and_css
    css_link asset("css/c3.min.css")
    js_link asset("js/c3.min.js")
    js_link asset("js/d3.v3.min.js")
  end
end