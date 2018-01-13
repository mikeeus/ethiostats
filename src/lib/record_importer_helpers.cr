module RecordImporterHelpers

  @errors = [] of NamedTuple(msg: String, row: CSV)

  private def add_error(row, msg)
    @errors << {
      msg: msg,
      row: row
    }
  end

  private def write_out_errors
    if @errors.any?
      puts "There were errors:"
      pp @errors.map(&.[:msg])
    end
  end

  private def ensure_int_with_default(value, default)
    if value.empty?
      default
    else
      value.to_f.to_i64.to_s
    end
  end

  private def or_default(value, default)
    if value.empty?
      default
    else
      value
    end
  end

  private def nillify(value)
    if value.empty?
      nil
    else
      value
    end
  end

  private def to_cents(value)
    (value.to_f * 100).to_i64.to_s
  end

  def create_missing_hscode(row)
    zero_section = SectionQuery.new.code("00").first
    zero_chapter = ChapterQuery.new.code("0000").first
    zero_heading = HeadingQuery.new.code("000000").first

    hscode = HscodeForm.new(
      section_id: zero_section.id.to_s,
      chapter_id: zero_chapter.id.to_s,
      heading_id: zero_heading.id.to_s,
      code: row[@headers["code"]],
      description: row[@headers["description"]],
      unit: "UN",
      duty: "0",
      excise: "0",
      vat: "15",
      sur: "10",
      withholding: "3",
    )

    hscode.save!
    #   hscode
    # else
    #   pp hscode.errors
    #   raise "Error creating missing hscode."
    # end
  end
end