module Layout::FooterComponent
  private def footer
    footer class: "footer" do
      text "created by "
      link "mikias abera", to: "https://mikias.net"
    end
  end
end