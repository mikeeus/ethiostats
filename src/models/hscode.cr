# Post models a blog article.
# A Harmonized System code that describes a class of products and
# it's tariff rates for Ethiopia
class Hscode < BaseModel
  table :hscodes do
    belongs_to section : Section
    belongs_to chapter : Chapter
    belongs_to heading : Heading

    field code : String
    field description : String
    field unit : String
    field special_permission : String?

    field duty : Int32
    field excise : Int32
    field vat : Int32
    field sur : Int32
    field withholding : Int32
    field ss_1 : Int32?
    field ss_2 : Int32?
    field export_duty : Int32?
  end
end
