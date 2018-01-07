class ExportQuery < Export::BaseQuery
  def find_by_hash?(hash)
    unique_hash(hash).first?
  end
end
