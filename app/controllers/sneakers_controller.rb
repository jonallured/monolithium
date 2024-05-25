class SneakersController < ApplicationController
  skip_before_action :ensure_admin

  expose(:sneakers) do
    Sneaker.order(ordered_on: :desc)
  end
end
