class Hscodes::Show < BrowserAction
  get "/hscodes/:code" do
    hscode = HscodeQuery.new.code(code).first
    render hscode: hscode
  end
end