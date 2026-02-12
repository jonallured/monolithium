module Api
  module V1
    module TimeClock
      class FramesController < Api::V1Controller
        expose(:frames) do
          next_boop = Boop.next
          if next_boop
            [
              ::TimeClock::Frame.new(next_boop.display_type, "boop"),
              ::TimeClock::Frame.new(next_boop.display_type, next_boop.number.to_s)
            ]
          else
            [::TimeClock::Frame.default]
          end
        end
      end
    end
  end
end
