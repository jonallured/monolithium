module Api
  module V1
    module TimeClock
      class FramesController < Api::V1Controller
        expose(:frames) do
          next_boop = Boop.next
          if next_boop
            text = "boop ##{next_boop.number}"
            [::TimeClock::Frame.new(next_boop.display_type, text)]
          else
            [::TimeClock::Frame.default]
          end
        end
      end
    end
  end
end
