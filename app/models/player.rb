class Player < ApplicationRecord
  has_many :characters, dependent: :destroy
end
