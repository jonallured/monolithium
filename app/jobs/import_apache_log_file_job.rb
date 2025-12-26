class ImportApacheLogFileJob < ApplicationJob
  def perform(dateext)
    ApacheLogFile.import(dateext)
  end
end
