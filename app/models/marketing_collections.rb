class MarketingCollections
  BEST_SLUGS = %w[
    artists-on-the-rise
    artsy-vanguard-artists
    contemporary-now
    finds-under-1000-dollars
    iconic-prints
    top-auction-lots
    trending-this-week
    trove-editors-picks
  ].freeze

  def self.load_artworks(slugs = BEST_SLUGS)
    payloads = slugs.map do |slug|
      response = MetaphysicsApi.marketing_collection(slug)
      data = response.to_h
      edges = data.dig("marketingCollection", "artworksConnection", "edges") || []
      edges.map { |edge| edge["node"] }
    end.flatten

    return unless payloads.any?

    existing_gravity_ids = Artwork.pluck(:gravity_id)

    payloads.each do |payload|
      next if existing_gravity_ids.include?(payload["gravity_id"])

      Artwork.create(gravity_id: payload["gravity_id"], payload: payload)
    end
  end
end
