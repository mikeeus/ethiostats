class Hscodes::ShowSerializer
  def initialize(@hscode : Hscode)

  end

  def render
    {
      code: @hscode.code,
      description: @hscode.description,
      unit: @hscode.unit,
      special_permission: @hscode.special_permission,

      duty: @hscode.duty,
      excise: @hscode.excise,
      vat: @hscode.vat,
      sur: @hscode.sur,
      withholding: @hscode.withholding,
      ss_1: @hscode.ss_1,
      ss_2: @hscode.ss_2,
      export_duty: @hscode.export_duty
    }
  end
end