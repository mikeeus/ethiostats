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
      pp @errors
    else
      count = ImportQuery.new.count
      if @show_progress
        puts "Success: There are #{count} Imports in the database."
      end
    end
  end

  private def ensure_int_with_default(value, default)
    if value.empty?
      default
    else
      value.to_f.to_i.to_s
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
    (value.to_f * 100).to_i.to_s
  end
end