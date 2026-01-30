module Api
  module V1
    class WarmFuzziesController < Api::V1Controller
      expose(:warm_fuzzy, with: :random_or_find)

      expose(:warm_fuzzies) do
        WarmFuzzy.order(created_at: :desc).page(params[:page])
      end

      def create
        puts "*" * 80
        puts request.headers.to_h["CONTENT_TYPE"]
        puts params.keys
        puts warm_fuzzy.valid?
        puts warm_fuzzy.errors.messages
        puts "*" * 80
        warm_fuzzy.save!
        render :show, status: :created
      rescue => e
        puts e.class
        # puts e.backtrace
        head :unproccessible_entity
      end

      def update
        puts "*" * 80
        puts params.inspect
        puts warm_fuzzy_params.inspect
        puts "*" * 80
        warm_fuzzy.update!(warm_fuzzy_params)
        render :show
      end

      def destroy
        warm_fuzzy.destroy
        head :ok
      end

      private

      def warm_fuzzy_params
        params.require(:warm_fuzzy).permit(WarmFuzzy.permitted_params)
      end
    end
  end
end
