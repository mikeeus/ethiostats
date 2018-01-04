class Section < BaseModel
  table :sections do
    field code : String
    field description : String
  end
end
