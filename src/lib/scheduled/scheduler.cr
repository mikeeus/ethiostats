require "http/client"
require "schedule"

class Scheduler
  @base_url = "http://www.erca.gov.et/images/Documents/import_export/"
  @records_path = "records/source"

  def schedule
    handle_exceptions
    check_records
  end

  def check_records
    Schedule.every(100.second) do
      get_latest_exports
    end
  end

  def get_latest_exports
    model = "export"
    year = latest_export_year
    export_record_url = record_url(model, year)
    response = HTTP::Client.get(export_record_url)
    if response.status_code == 200
      filename = file_name(model, year)
      file = File.open("#{@records_path}/#{model}/temp_#{filename}", response.body)
      existing = File.open("#{@records_path}/#{model}/#{filename}")

      # check if file size is the same
      if existing.size == file.size
        return
      else
        # overwrite
        # import
      end
    else
      puts "failed to get #{export_record_url}"
    end
  end

  # TODO: email on success
  private def notify
    puts "successfully updated!"
  end

  private def record_url(model, year)
    @base_url + file_name(model, year)
  end

  private def file_name(model, year)
    "#{model}_#{year}.xlsx"
  end

  private def latest_export_year : Int32
    year = Time.new.year + 1

    latest = nil
    while latest.nil?
      year -= 1
      latest = ExportQuery.new.year(year).order_by(:month, :desc).first?
    end

    if latest
      latest_month = latest.month
    else
      raise "latest export record not found"
    end

    if latest_month == 12
      year += 1
    end

    year
  end

  # Set a default exception handler
  private def handle_exceptions
    Schedule.exception_handler do |ex|
      puts "Exception rescued! #{ex.message}"
    end
  end
end
