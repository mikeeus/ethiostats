class Country < BaseModel
  table :countries do
    field name : String
    field short : String
    field coordinates : String?
    # field aliases : Array(String)
  end
end
