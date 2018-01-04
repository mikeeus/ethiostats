class Chapter < BaseModel
  table :chapters do
    belongs_to section : Section

    field code : String
    field description : String
  end
end
