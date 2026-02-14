class ImportNewBlogPostsJob < ApplicationJob
  def perform
    BlogPost::Importer.add_new
  end
end
