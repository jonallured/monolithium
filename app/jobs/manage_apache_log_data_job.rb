class ManageApacheLogDataJob < ApplicationJob
  def perform
    ApacheLogFile::Manager.process_files
  end
end
