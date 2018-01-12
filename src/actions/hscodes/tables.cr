class Hscodes::Tables < BrowserAction
  get "/hscodes/:code/tables" do
    hscode = HscodeQuery.new.code(code).first
    page = request.query_params["page"]
    page_length = request.query_params["page_length"] || 10

    # json({
    #   imports: hscode.imports_by_year,
    #   exports: hscode.exports_by_year
    # }, 200)
    json({some: "thing"}, 200)
  end
end