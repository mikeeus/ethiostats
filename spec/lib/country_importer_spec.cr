require "../spec_helper.cr"
require "../support/factories.cr"
require "../../src/lib/country_importer.cr"

describe CountryImporter do
  Spec.before_each do
    seed_countries
  end

  # NOTE: `spec_helper` truncates the database after each test
  # so I'm nesting the tests in a single it block to avoid
  # multiple database calls.
  it "imports countries" do
    it "handles special characters in names" do
      all_countries = CountryQuery.new.count
      all_countries.should eq 3
    end

    it "imports countries with their aliases" do
      south_korea = CountryQuery.new.first
      south_korea.short.should eq "KR"
      south_korea.name.should eq "South Korea"

      aliases = LuckyRecord::Repo.run do |db|
        db.query_all "SELECT aliases FROM countries WHERE name = 'South Korea'",
          as: Array(String)
      end.first
      aliases.size.should eq 15
    end
  end
end
