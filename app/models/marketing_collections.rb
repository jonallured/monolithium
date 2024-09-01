class MarketingCollections
  SLUGS = %w[
    artists-on-the-rise
    artsy-vanguard-artists
    contemporary-now
    finds-under-1000-dollars
    iconic-prints
    street-art-highlights
    top-auction-lots
    trending-this-week
    trove-editors-picks
  ].freeze

  def self.load_artworks
    SLUGS.each do |slug|
      data = MetaphysicsApi.marketing_collection(slug)
      nodes = data.marketing_collection.artworks_connection.edges.map(&:node)
      new_nodes = nodes.reject { |node| Artwork.exists?(gravity_id: node.gravity_id) }
      new_nodes.each do |node|
        Artwork.create(gravity_id: node.gravity_id, payload: node.to_h)
      end
    end
  end
end
