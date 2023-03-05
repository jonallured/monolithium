module Api
  module V1
    class RawHooksController < Api::V1Controller
      skip_before_action :validate_client_token

      expose(:raw_hook) do
        attrs = HookRequest.to_attrs(request, params)
        RawHook.new(attrs)
      end

      def create
        if raw_hook.save
          head :created
        else
          head :unprocessable_entity
        end
      end
    end
  end
end
