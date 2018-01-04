class Country < BaseModel
  table :chapters do
    field name : String
    field short : String
    field coordinates : String?
    # field aliases : Array(String)
  end
end
