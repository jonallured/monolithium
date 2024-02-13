class ModelCountsController < ApplicationController
  expose(:model_counts) { ModelCounts.calculate }
end
