class Hscodes::Search < BrowserAction
  get "/hscodes/search" do
    results = HscodeQuery.new.search(request.query_params["term"])

    json(results.to_json_array, 200)
  end
end
