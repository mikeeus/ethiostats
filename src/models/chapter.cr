class Chapter < BaseModel
  table :chapters do
    belongs_to section : Section

    field code : String
    field description : String

    has_many hscodes : Hscode
  end
end
