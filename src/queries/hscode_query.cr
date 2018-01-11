class HscodeQuery < Hscode::BaseQuery
  def search(term : String)
    description.ilike("%#{term}%")
  end

  def to_json_array
    Hscodes::IndexSerializer.new(self.results).render
  end

  def to_json
    Hscodes::ShowSerializer.new(self.results).render
  end
end
