module Api
  module V1
    class EntriesController < Api::V1Controller
      expose(:payload) do
        timestamp = Time.current.strftime('%m/%d/%y %I:%M %P')
        EntryLoader.load.merge timestamp: timestamp
      end

      def update
        data = JSON.parse request.body.read
        EntryUpdater.update(data)
        head :no_content
      end
    end
  end
end
