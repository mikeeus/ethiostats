require "./import_progress_helpers.cr"

class HsClassificationImporter
  include ImportProgressHelpers

  def initialize(@csv : CSV, @length : Int32, @show_progress = true)
    # skip first row after header
    @csv.next
  end

  def call
    @csv.each do |row|
      if row["Tier"] == "1"
        import_section(row)
      elsif row["Tier"] == "2"
        import_chapter(row)
      elsif row["Tier"] == "3"
        import_heading(row)
      end
      increment_progress
    end
  end

  # Import section
  private def import_section(row)
    code = row["ProductCode"]
    return if section_exists?(code)

    section = SectionForm.new(
      code: code,
      description: row["Product Description"]
    )
    if section = section.save!
      # Add zeroed chapters to section
      save_zero_chapter(section)
    end
  end

  # Import chapter
  private def import_chapter(row)
    code = row["ProductCode"]
    return if chapter_exists?(code)

    section = SectionQuery.new.code(code.rchop.rchop).first
    chapter = ChapterForm.new(
      section_id: section.id.to_s,
      code: code,
      description: row["Product Description"]
    )
    if chapter = chapter.save!
      # Add zeroed heading to chapter
      save_zero_heading(chapter)
    end
  end

  # Import headings
  private def import_heading(row)
    return if heading_exists?(row["ProductCode"])

    chapter = ChapterQuery.new.code(row["ProductCode"].rchop.rchop).first
    heading = HeadingForm.new(
      chapter_id: chapter.id.to_s,
      code: row["ProductCode"],
      description: row["Product Description"]
    )
    heading.save!
  end

  private def section_exists?(code)
    SectionQuery.new.code(code).first?
  end

  private def chapter_exists?(code)
    ChapterQuery.new.code(code).first?
  end

  private def heading_exists?(code)
    HeadingQuery.new.code(code).first?
  end

  # Zero chapters are fillers for sections
  private def save_zero_chapter(section : Section)
    code = section.code + "00"
    return if chapter_exists?(code)

    chapter = ChapterForm.new(
      section_id: section.id.to_s,
      code: code,
      description: "---"
    )
    if chapter = chapter.save!
      save_zero_heading(chapter)
    end
  end

  # Zero headings are fillers for zero chapters
  private def save_zero_heading(chapter : Chapter)
    code = chapter.code + "00"
    return if heading_exists?(code)

    heading = HeadingForm.new(
      chapter_id: chapter.id.to_s,
      code: code,
      description: "---"
    )
    heading.save!
  end
end
