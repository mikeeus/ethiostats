class ImportQuery < Import::BaseQuery
  # Returns true if an import with the given properties is not found
  def is_unique(hscode_id, year, month, cpc, origin_id, consignment_id, cif_etb, cif_usd)
    where(hscode_id: hscode_id, year: year, month: month, cpc: cpc, origin_id: origin_id, consignment_id: consignment_id, cif_etb: cif_etb, cif_usd: cif_usd).first?
  end
end