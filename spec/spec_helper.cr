ENV["LUCKY_ENV"] = "test"
require "spec"
require "../src/app"
require "./support/**"
require "../src/lib/**"

Spec.after_each do
  truncate_database
end

def truncate_database
  LuckyRecord::Repo.truncate
end
