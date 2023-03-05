class CybertailController < ApplicationController
  expose(:hooks) { Hook.all.order(created_at: :desc).limit(10) }
end
