class HscodeForm < Hscode::BaseForm
  allow section_id
  allow chapter_id
  allow heading_id

  allow code
  allow description
  allow unit
  allow special_permission

  allow duty
  allow excise
  allow vat
  allow sur
  allow withholding
  allow ss_1
  allow ss_2

  def prepare
    validate_required section_id
    validate_required chapter_id
    validate_required heading_id
    validate_required code
    validate_required description
    validate_required unit

    validate_required duty
    validate_required excise
    validate_required vat
    validate_required sur
    validate_required withholding
  end
end