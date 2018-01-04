class Heading < BaseModel
  table :headings do
    belongs_to chapter : Chapter
    field code : String
    field description : String
  end
end
