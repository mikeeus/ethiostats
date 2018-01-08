class ImportRecords::HeaderBuilder
  def initialize(@year : Int32)
  end

  def build
    headers = default_labels

    if @year < 2007
      headers.merge!(lt2007_labels)
    else
      headers.merge!(gte2007_labels)
    end

    if @year >= 2017
      headers.merge!(gte2017_labels)
    end

    headers
  end

  private def default_labels
    {
      "year" => "Year",
      "code" => "HS Code",
      "description" => "HS Description",
      "origin" => "Country (Origin)",
      "consignment" => "Country (Consignment)",
      "quantity" => "Quantity",
      "cif_etb" => "CIF Value (ETB)",
      "cif_usd" => "CIF Value (USD)"
    }
  end

  private def lt2007_labels
    { "unit" => "Unit", "mass_net" => "Net Mass (Kg)" }
  end

  private def gte2007_labels
    {
      "month" => "Month",
      "cpc" => "CPC",
      "unit" => "Unit",
      "mass_gross" => "Gross Wt. (Kg)",
      "mass_net" => "Net Wt. (Kg)",
      "tax_etb" => "Total tax (ETB)",
      "tax_usd" => "Total tax (USD)",
    }
  end

  private def gte2017_labels
    { "unit" => "Sup. Unit" }
  end
end