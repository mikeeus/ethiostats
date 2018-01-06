require "progress"

module ImportProgressHelpers
  @bar = ProgressBar.new
  @count = 0

  # Increment progress bar every 1/100th of the csv's length
  private def increment_progress
    return unless @show_progress

    @count += 1
    if @count % (@length / 100) == 0
      @bar.inc
    end
  end
end