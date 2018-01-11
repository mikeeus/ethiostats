class Hscodes::Show < BrowserAction
  action do
    hscode = HscodeQuery.new.code(id).first
    render hscode: hscode
  end
end