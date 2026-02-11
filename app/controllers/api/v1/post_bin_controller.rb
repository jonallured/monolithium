module Api
  module V1
    class PostBinController < Api::V1Controller
      expose(:post_bin_request) do
        attrs = HookRequest.to_attrs(request, params)
        PostBinRequest.new(attrs)
      end

      def create
        post_bin_request.save
        status = request.get? ? :ok : :created
        head status
      end
    end
  end
end
