require "schedule"
require "../src/lib/scheduled/scheduler.cr"

class ScheduledTasks < LuckyCli::Task
  banner "scheduled tasks"

  def call
    Scheduler.new.schedule
    # sleep
  end
end