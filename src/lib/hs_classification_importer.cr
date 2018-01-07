require "./import_progress_helpers.cr"

class HsClassificationImporter
  include ImportProgressHelpers

  def initialize(@csv : CSV, @length : Int32, @show_progress = true)
    # skip first row after header
    @csv.next
  end

  def call
    # First import zero section for missing codes
    import_zero_section

    # Iterate through the CSV's rows accessing columns with
    # their header names. We can do this because we instantiated
    # CSV with `headers: true`.
    @csv.each do |row|
      # NOTE: CSV rows are parsed as strings. So you might need to
      # convert it to your desired type. We won't need to worry in
      # this case because Lucky Forms converts string parameters
      # automatically.
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

  private def import_zero_section
    code = "00"
    return if section_exists?(code)

    desc = "Deprecated or missing codes."
    section = SectionForm.new(code: code, description: desc)

    if section = section.save!
      save_zero_chapter(section)
    end
  end

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
      save_zero_heading(chapter)
    end
  end

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

  # Check if section exists by querying it by code.
  # `first?` will return nil if record is not found.
  private def section_exists?(code)
    SectionQuery.new.code(code).first?
  end

  private def chapter_exists?(code)
    ChapterQuery.new.code(code).first?
  end

  private def heading_exists?(code)
    HeadingQuery.new.code(code).first?
  end

  # Zeroed chapters and headings are fillers
  private def save_zero_chapter(section : Section)
    code = section.code + "00"
    return if chapter_exists?(code)

    # NOTE: we save associations by saving the foreign_key.
    # We convert the id to a string because Lucky excpects
    # form parameters to be strings (for now).
    chapter = ChapterForm.new(
      section_id: section.id.to_s,
      code: code,
      description: "---"
    )

    # `save!` raises an error on failure or returns the new model.
    # We pass the saved model to the next method.
    if chapter = chapter.save!
      save_zero_heading(chapter)
    end
  end

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
