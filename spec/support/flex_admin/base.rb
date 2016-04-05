require "json_api_client"
module MyApp
  module Test
    module Models
      class Base < JsonApiClient::Resource
        self.site = ENV["FLEX_ADMIN_URL"]
        property :id, type: :integer, default: 0
        collection_endpoint :delete_all, request_method: :delete
        class << self
          def delete_all
            requestor.custom("", { request_method: :delete }, {})
          end
        end

      end
      Base.connection do |connection|
        connection.faraday.basic_auth(ENV["FLEX_ADMIN_USERNAME"], ENV["FLEX_ADMIN_PASSWORD"])
      end

    end
  end
end