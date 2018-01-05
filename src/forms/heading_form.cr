class HeadingForm < Heading::BaseForm
  allow chapter_id
  allow code
  allow description

  def prepare
    validate_required chapter_id
    validate_required code
    validate_required description
  end
end