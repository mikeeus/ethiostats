abstract class MainLayout
  include Lucky::HTMLPage
  include Shared::FieldErrorsComponent
  include Shared::FlashComponent
  include Charts::Components
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
        favicons
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

  private def favicons
    raw %(
      <link rel="apple-touch-icon" sizes="76x76" href="/images/favicons/apple-touch-icon.png">
      <link rel="icon" type="image/png" sizes="32x32" href="/images/favicons/favicon-32x32.png">
      <link rel="icon" type="image/png" sizes="16x16" href="/images/favicons/favicon-16x16.png">
      <link rel="manifest" href="/images/favicons/manifest.json">
      <link rel="mask-icon" href="/images/favicons/safari-pinned-tab.svg" color="#5bbad5">
    )
  end
end
