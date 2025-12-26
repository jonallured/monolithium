class ApacheLogFile::Loader < ActiveRecord::AssociatedObject
  class NotTransformedError < StandardError; end

  def run
    raise NotTransformedError unless apache_log_file.transformed?

    apache_log_file.parsed_entries.each do |parsed_entry|
      apache_log_item = apache_log_file.apache_log_items.new(parsed_entry)

      if apache_log_item.valid?
        apache_log_item.save
      else
        apache_log_item.destroy
      end
    end

    apache_log_file.update!(state: "loaded")
  end
end
