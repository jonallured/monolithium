require "graphql/client"
require "graphql/client/http"

class MetaphysicsApi
  TOKEN_FILENAME = "introspection_token.txt".freeze
  SCHEMA_FILENAME = "mp_schema.json".freeze

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
    endpoint_url = Monolithium.config.metaphysics_endpoint_url
    return unless endpoint_url

    fetch_auth_token unless File.exist?(Rails.root.join(TOKEN_FILENAME).to_s)

    GraphQL::Client::HTTP.new(endpoint_url) do
      def headers(_context) # rubocop:disable Lint/NestedMethodDefinition
        introspection_token = File.read(Rails.root.join(TOKEN_FILENAME).to_s).chomp
        {"Authorization" => "Bearer #{introspection_token}"}
      end
    end
  end

  def self.raw_http_client
    endpoint_url = Monolithium.config.metaphysics_endpoint_url
    return unless endpoint_url

    GraphQL::Client::HTTP.new(endpoint_url)
  end

  def self.generate_schema
    schema_path = Rails.root.join(SCHEMA_FILENAME).to_s

    GraphQL::Client.dump_schema(generate_authenticated_client, schema_path) unless File.exist?(schema_path)

    GraphQL::Client.load_schema(schema_path)
  end

  def self.schema
    @schema ||= generate_schema
  end

  def self.generate_client
    return unless raw_http_client

    GraphQL::Client.new(schema: schema, execute: raw_http_client)
  end

  def self.client
    @client ||= generate_client
  end

  def self.marketing_collection(slug)
    return unless client
    query = MetaphysicsOperations::MARKETING_COLLECTION_QUERY
    return unless query

    variables = {"slug" => slug}
    context = {}
    result = MetaphysicsApi.client.query(query, variables: variables, context: context)
    result.data
  end
end
