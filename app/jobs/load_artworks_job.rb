class LoadArtworksJob < ApplicationJob
  def perform
    MarketingCollections.load_artworks
  end
end
