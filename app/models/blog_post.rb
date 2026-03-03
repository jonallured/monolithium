class BlogPost < ApplicationRecord
  after_create_commit :created

  has_object :announcer

  validates :number, presence: true
  validates :published_on, presence: true
  validates :summary, presence: true
  validates :title, presence: true
  validates :url, uniqueness: true

  def image_url
    "https://www.jonallured.com/images/post-#{number}/social-share.png"
  end

  private

  def created
    announcer.run
  end
end
