require 'graphql/client'
require 'graphql/client/http'

class Metaphysics
  ENDPOINT_URL = 'https://metaphysics-production.artsy.net/v2'.freeze

  def self.fetch_auth_token
    commands = <<-BASH
      cd ../metaphysics
      hokusai production env get INTROSPECT_TOKEN \
        | cut -f 2 -d "=" \
        > ../monolithium/introspection_token.txt
      cd ../monolithium
    BASH

    system commands
  end

  def self.generate_raw_client
    fetch_auth_token unless File.exist?('introspection_token.txt')

    GraphQL::Client::HTTP.new(ENDPOINT_URL) do
      def headers(_context) # rubocop:disable Lint/NestedMethodDefinition
        introspection_token = File.read('introspection_token.txt').chomp
        { 'Authorization' => "Bearer #{introspection_token}" }
      end
    end
  end

  def self.raw_http_client
    @raw_http_client ||= generate_raw_client
  end

  def self.generate_schema
    local_schema_path = 'mp_schema.json'

    GraphQL::Client.dump_schema(raw_http_client, local_schema_path) unless File.exist?(local_schema_path)

    GraphQL::Client.load_schema(local_schema_path)
  end

  def self.schema
    @schema ||= generate_schema
  end

  def self.client
    @client ||= GraphQL::Client.new(schema: schema, execute: raw_http_client)
  end

  def self.marketing_collection(slug)
    variables = { 'slug' => slug }
    context = {}
    result = Metaphysics.client.query(MarketingCollectionQuery, variables: variables, context: context)
    result.data
  end
end

MarketingCollectionQuery = Metaphysics.client.parse <<-'GRAPHQL'
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
