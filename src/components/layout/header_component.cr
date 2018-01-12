module Layout::HeaderComponent
  include Hscodes::AutocompleteComponent

  private def header
    div class: "nav" do
      link "Ethiostats", class: "brand", to: "/"
      # ul role: "navigation" do
      # end
      hscode_autocomplete "Search records: eg. Coffee, Gold, Petroleum, ...", "header-search-hscodes"
    end
  end
end