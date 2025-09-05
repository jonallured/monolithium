class CrawlArtworksJob < ApplicationJob
  def perform
    Artwork::Loader.crawl_collections
  end
end
