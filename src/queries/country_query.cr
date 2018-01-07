class CountryQuery < Country::BaseQuery
  def find_by_name?(name : String)
    LuckyRecord::Repo.run do |db|
      _name = PG::EscapeHelper.escape_literal(name)
      statement = "SELECT id, name, short, coordinates, created_at, updated_at FROM countries WHERE name ILIKE #{_name} OR #{_name} ILIKE ANY (aliases)"
      db.query_one? statement, as: Country
    end
  end
end
