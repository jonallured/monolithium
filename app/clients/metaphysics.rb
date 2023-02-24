require 'graphql/client'
require 'graphql/client/http'

class Metaphysics
  ENDPOINT_URL = 'https://metaphysics-production.artsy.net/v2'.freeze
  TOKEN_FILENAME = 'introspection_token.txt'.freeze
  SCHEMA_FILENAME = 'mp_schema.json'.freeze

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

  def self.generate_authenticated_client
    fetch_auth_token unless File.exist?(Rails.root.join(TOKEN_FILENAME).to_s)

    GraphQL::Client::HTTP.new(ENDPOINT_URL) do
      def headers(_context) # rubocop:disable Lint/NestedMethodDefinition
        introspection_token = File.read(Rails.root.join(TOKEN_FILENAME).to_s).chomp
        { 'Authorization' => "Bearer #{introspection_token}" }
      end
    end
  end

  def self.raw_http_client
    @raw_http_client ||= GraphQL::Client::HTTP.new(ENDPOINT_URL)
  end

  def self.generate_schema
    schema_path = Rails.root.join(SCHEMA_FILENAME).to_s

    GraphQL::Client.dump_schema(generate_authenticated_client, schema_path) unless File.exist?(schema_path)

    GraphQL::Client.load_schema(schema_path)
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

MarketingCollectionQuery = Metaphysics.client.parse <<-GRAPHQL
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
