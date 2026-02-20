class BlogPost < ApplicationRecord
  validates :number, presence: true
  validates :published_on, presence: true
  validates :summary, presence: true
  validates :title, presence: true
  validates :url, uniqueness: true
end
