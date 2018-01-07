require "csv"
require "./import_progress_helpers.cr"
require "./record_importer_helpers.cr"

class HscodeImporter
  include ImportProgressHelpers
  include RecordImporterHelpers

  @labels = {
    code: "HS Code",
    description: "HS Description",
    unit: "Suppl. Unit",
    special_permission: "Special Permission",
    duty: "Duty Tax Rate",
    excise: "Excise Tax Rate",
    vat: "VAT Rate",
    sur: "Sur Tax Rate",
    withholding: "With Hold Rate",
    ss_1: "Second Schedule 1",
    ss_2: "Second Schedule 2",
    export_duty: "Export Duty Tax Rate"
  }

  def initialize(@csv : CSV, @length : Int32, @show_progress = true)
  end

  def call
    @csv.each do |row|
      if hscode_exists?(row)
        increment_progress
        next
      end

      # parse codes
      code = row[@labels[:code]]
      if code.size == 7
        section_code = "0" + code[-7,1]
      else
        section_code = code[-8,2]
      end
      chapter_code = section_code + code[-6,2]
      heading_code = chapter_code + code[-4,2]

      # get section
      section = SectionQuery.new.code(section_code).first?
      if section.nil?
        add_error(row, "Section with code: #{section_code} not found!")
        increment_progress
        next
      end

      chapter = ChapterQuery.new.code(chapter_code).first?
      if chapter.nil?
        add_error(row, "Chapter with code: #{chapter_code} not found!")
        increment_progress
        next
      end

      heading = HeadingQuery.new.code(heading_code).first?
      if heading.nil?
        heading = create_heading(chapter, heading_code)
      end

      hscode = new_hscode_from row, section, chapter, heading

      if hscode.save
        increment_progress
      else
        pp hscode.errors
        raise "Problem importing hscode"
      end
    end

    write_out_errors
    if @show_progress
      count = HscodeQuery.new.count
      puts "Success: There are #{count} Imports in the database."
    end
  end

  private def new_hscode_from(row, section, chapter, heading)
    HscodeForm.new(
      section_id: section.id.to_s,
      chapter_id: chapter.id.to_s,
      heading_id: heading.id.to_s,
      code: row[@labels[:code]],
      description: row[@labels[:description]],
      unit: or_default(row[@labels[:unit]], "UN"),
      special_permission: row[@labels[:special_permission]],
      duty: or_default(row[@labels[:duty]], "0"),
      # somehow excise get's parsed to "100.0" and needs to be converted
      excise: ensure_int_with_default(row[@labels[:excise]], "0"),
      vat: or_default(row[@labels[:vat]], "15"),
      sur: or_default(row[@labels[:sur]], "10"),
      withholding: or_default(row[@labels[:withholding]], "3"),
      ss_1: row[@labels[:ss_1]],
      ss_2: row[@labels[:ss_2]],
      export_duty: row[@labels[:export_duty]],
    )
  end

  private def create_heading(chapter : Chapter, heading_code : String)
    HeadingForm.new(
      chapter_id: chapter.id.to_s,
      code: heading_code,
      description: "--"
    ).save!
  end

  private def hscode_exists?(row)
    HscodeQuery.new.code(row[@labels[:code]]).first?
  end
end
