module Indexable
  extend ActiveSupport::Concern

  NEXT_PAGE_HEADER = "X-Next-Page"
  TOTAL_COUNT_HEADER = "X-Total-Count"

  included do
    class_attribute :indexed_model, instance_writer: false
    rescue_from IndexQuery::InvalidParam, with: :invalid_index_param
  end

  class_methods do
    def index_model(model)
      self.indexed_model = model
    end
  end

  def index
    records = index_query.records
    response.headers[TOTAL_COUNT_HEADER] = records.total_count.to_s
    response.headers[NEXT_PAGE_HEADER] = records.next_page.to_s if records.next_page
  end

  private

  def index_query
    @index_query ||= IndexQuery.new(indexed_model, request.query_parameters)
  end

  def invalid_index_param(error)
    render json: {error: error.message}, status: :bad_request
  end
end
