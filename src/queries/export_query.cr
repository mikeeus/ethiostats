class ExportQuery < Export::BaseQuery
  # Returns true if an export with the given properties is not found
  def is_unique(hscode_id, year, month, cpc, destination_id, fob_etb, fob_usd)
    where(hscode_id: hscode_id, year: year, month: month, cpc: cpc, destination_id: destination_id, fob_etb: fob_etb, fob_usd: fob_usd).first?
  end
end