class CountryForm < Country::BaseForm
  allow name
  allow short
  allow coordinates
  allow aliases

  def prepare
    validate_required name
    validate_required short
  end
end