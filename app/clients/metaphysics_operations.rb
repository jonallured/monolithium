module MetaphysicsOperations
  MARKETING_COLLECTION_QUERY = MetaphysicsApi.client&.parse <<-GRAPHQL
  query($slug: String!) {
    marketingCollection(slug: $slug) {
      artworksConnection(first: 100, sort: "-published_at") {
        edges {
          node {
            blurb:formattedMetadata
            gravity_id:internalID
            href
            image {
              aspect_ratio:aspectRatio
              position
              url(version: ["normalized", "larger"])
            }
          }
        }
      }
    }
  }
  GRAPHQL
end
