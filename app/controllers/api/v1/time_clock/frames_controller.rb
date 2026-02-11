module Api
  module V1
    module TimeClock
      class FramesController < Api::V1Controller
        expose(:frames) { [::TimeClock::Frame.default] }
      end
    end
  end
end
