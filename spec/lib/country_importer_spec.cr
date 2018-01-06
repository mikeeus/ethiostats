require "../spec_helper.cr"
require "../../src/lib/country_importer.cr"

# We'll use data that contains our edge cases: special characters
# and aliases
def import_test_countries
  data = YAML.parse <<-END
    countries:
      - KR	35.907757	127.766922	South Korea
      - CI	7.539989	-5.54708	Côte d'Ivoire
      - FK	-51.796253	-59.523613	Falkland Islands [Islas Malvinas]
    aliases:
      South Korea:
        - Korea
        - Democratic People's Rep. of
        - Korea
        - Democratic People's Rep.
        - Korea Dem.People's Rep. Of
        - Korea
        - Dem.People's Rep. Of
        - Korea Democratic People&#39;s Rep. of
        - Korea  Dem.People&#39;s Rep. Of
        - Korea Democratic People's Rep.
        - Korea Republic Of
        - Korea Republic of
        -  Korea
        - Republic of
        - Korea  Republic Of
  END

  # Get countries array and aliases object from data
  countries = data["countries"].to_a
  aliases = data["aliases"]
  # Import countries
  CountryImporter.new(countries, aliases, show_progress: false).call
end

describe CountryImporter do
  Spec.before_each do
    import_test_countries
  end

  # NOTE: `spec_helper` truncates the database after each test
  # so I'm putting the tests in a single block to avoid
  # multiple database calls.
  it "imports countries with all countries with special characters" do
    all_countries = CountryQuery.new.count
    all_countries.should eq 3

    # "imports countries with their aliases"
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
