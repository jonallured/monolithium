class BlogPost < ApplicationRecord
  has_object :announcer

  after_create_commit :created

  private

  def created
    # this probably should be in a job:
    # announcer.run
  end
end
