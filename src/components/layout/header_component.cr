module Layout::HeaderComponent
  private def header
    div class: "nav" do
      link "Ethiostats", class: "brand", to: "/"
      # ul role: "navigation" do
      # end
    end
  end
end