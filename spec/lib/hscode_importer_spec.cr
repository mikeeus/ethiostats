require "csv"
require "../spec_helper.cr"
require "../support/factories.cr"

describe HscodeImporter do
  # We'll import the hs classes then the hscodes from our csv objects.
  Spec.before_each do
    seed_hscodes
  end

  # NOTE: `spec_helper` truncates the database after each test
  # so I'm nesting the tests in a single it block to avoid
  # multiple database calls.
  it "imports hscodes" do
    it "with associations" do
      hscode = HscodeQuery.new.find(1)
      hscode.section.code.should eq "01"
      hscode.chapter.code.should eq "0101"
      hscode.heading.code.should eq "010110"
    end

    it "creates missing heading" do
      missing_heading = HscodeQuery.new.find(2)
      missing_heading.description.should eq "MISSING HEADING"
      missing_heading.heading.description.should eq "--"
    end

    it "sets defaults" do
      sets_defaults = HscodeQuery.new.find(3)
      sets_defaults.description.should eq "SETS DEFAULTS"
      sets_defaults.unit.should eq "UN"
      sets_defaults.duty.should eq 0
      sets_defaults.excise.should eq 0
      sets_defaults.vat.should eq 15
      sets_defaults.sur.should eq 10
      sets_defaults.withholding.should eq 3
    end
  end
end
