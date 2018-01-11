class Hscodes::ShowPage < MainLayout
  needs hscode : Hscode

  def inner
    div class: "hscodes-wrapper" do
      div class: "hscodes-row-1" do
        div class: "hscodes-code" do
          text @hscode.code
        end
        div class: "hscodes-rates" do
          text "Rates"
        end
      end
      div class: "hscodes-row-2" do
        div class: "hscodes-related" do
          text "Related"
        end

        div class: "hscodes-chart" do
          text "Chart"
        end
      end

      div class: "hscodes-row-3" do
        text "Tables"
      end
    end
  end
end