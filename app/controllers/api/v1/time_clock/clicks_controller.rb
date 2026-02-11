module Api
  module V1
    module TimeClock
      class ClicksController < Api::V1Controller
        def create
          head :ok
        end
      end
    end
  end
end
