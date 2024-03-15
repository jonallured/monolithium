class FuzziesController < ApplicationController
  expose(:fuzzies) do
    ids = WarmFuzzy.all.pluck(:id).sample(10)
    WarmFuzzy.find(ids)
  end
end
