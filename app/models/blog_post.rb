class BlogPost < ApplicationRecord
  validates :url, uniqueness: true
end
