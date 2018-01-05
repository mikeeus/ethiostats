class ChapterForm < Chapter::BaseForm
  allow section_id
  allow code
  allow description

  def prepare
    validate_required section_id
    validate_required code
    validate_required description
  end
end