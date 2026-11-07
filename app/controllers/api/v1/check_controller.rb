module Api
  module V1
    class CheckController < Api::V1Controller
      def show
        render plain: Time.now.to_i
      end
    end
  end
end
