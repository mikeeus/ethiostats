class SectionForm < Section::BaseForm
  allow code
  allow description

  def prepare
    validate_required code
    validate_required description
  end
end
