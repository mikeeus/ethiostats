abstract class MainLayout
  include Lucky::HTMLPage
  include Shared::FieldErrorsComponent
  include Shared::FlashComponent
  include Shared::ChartsComponents
  include Layout::HeaderComponent
  include Layout::FooterComponent

  # You can put things here that all pages need
  #
  # Example:
  #   needs current_user : User

  abstract def inner

  def render
    html_doctype

    html lang: "en" do
      head do
        utf8_charset
        title page_title
        css_link asset("css/app.css")
        js_link asset("js/app.js")
        css_link asset("css/auto-complete.css")
        js_link asset("js/auto-complete.min.js")
        js_link asset("js/datatable.min.js")
        css_link asset("css/datatable.min.css")
        c3_scripts_and_css
        csrf_meta_tags
        meta name: "viewport", content: "width=device-width, initial-scale=1"
      end

      body do
        render_flash
        header
        div id: "content-wrapper" do
          inner
        end
        footer
      end
    end
  end

  def page_title
    "Ethiostats"
  end
end
