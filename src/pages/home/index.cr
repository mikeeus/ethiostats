class Home::IndexPage < MainLayout
  include Hscodes::AutocompleteComponent
  include Charts::HomepageComponent

  def inner
    div class: "homepage-wrapper" do
      # h1 "Ethiopian Trade Statistics"
      search_hscodes
      div class: "homepage-chart-intro" do
        div class: "homepage-chart" do
          homepage_chart
        end
        div class: "homepage-intro" do
          home_intro
        end
      end
    end
  end

  private def home_intro
    para "The purpose of this site is to make Ethiopian import and export statistics available in a userfriendly and clear format in order to promote:"
    ul do
      li do
        h3 "Investment"
        para "assist potential investors discover opportunities for import substitution."
      end
      li do
        h3 "Growth"
        para "help businesses identify developing trends to guide decisions."
      end
      li do
        h3 "Research"
        para "serve as a reference for students, researchers and decision makers."
      end
    end
    para "You can search and select an HS Code from the table, select a country from the drop down in the header or check out one of the annual summaries from the dropdown link above. Good luck and happy browsing!"
    small do
      text "The data on this site is available to the public from the "
      link "Ethiopian Revenue and Customs Authority (ERCA)", to: "http://www.erca.gov.et/"
      text " and is updated every two months."
    end
  end
end
