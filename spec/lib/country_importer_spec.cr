require "../spec_helper.cr"
require "../../src/lib/country_importer.cr"

data = YAML.parse <<-END
  countries:
    - KR,	35.907757,	127.766922,	South Korea
    - CI,	7.539989,	-5.54708,	Côte d'Ivoire
    - FK,	-51.796253,	-59.523613,	Falkland Islands [Islas Malvinas]
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

describe CountryImporter do
  Spec.before_each do
    countries = data["countries"].to_a
    aliases = data["aliases"]
    CountryImporter.new(countries, aliases, show_progress: false).call
  end

  Spec.after_each do
    LuckyRecord::Repo.run { |db| db.exec "DELETE from countries;" }
  end

  it "imports countries with special characters and their aliases" do
    all_countries = CountryQuery.new.count
    all_countries.should eq 3

    aliases = LuckyRecord::Repo.run do |db|
      db.query_all "SELECT aliases FROM countries WHERE name = 'South Korea'", as: Array(String)
    end.first
    aliases.size.should eq 15
  end
end
