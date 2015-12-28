require 'base64'
require 'openssl'
require 'digest'
require 'json'

module Aliyun
  module Odps
    class Authorization
      PROVIDER = 'ODPS'

      # @private
      #
      # Get authorization key
      #
      # @param access_key [String] Access Key
      # @param secret_key [String] Secret Key
      # @param options [Hash] Options
      # @option options [String] :verb VERB, request method
      # @option options [String] :date Request Time in formate: '%a, %d %b %Y %H:%M:%S GMT'
      # @option options [String] :bucket Bucket Name
      # @option options [String] :key Object Name
      # @option options [Hash] :query Query key-value pair
      # @option options [Hash] :headers Headers
      #
      # @return [String] the authorization string
      def self.get_authorization(access_key, secret_key, options = {})
        content_string = concat_content_string(options[:verb], options[:date], options)
        signature_string = signature(secret_key, content_string)
        "#{PROVIDER} #{access_key}:#{signature_string.strip}"
      end

      # @!visibility private
      def self.concat_content_string(verb, time, options = {})
        headers = options.fetch(:headers, {})

        conon_headers = get_cononicalized_odps_headers(headers)
        conon_resource = get_cononicalized_resource(
          *options.values_at(:path, :query)
        )

        join_values(verb, time, headers, conon_headers, conon_resource)
      end

      # @!visibility private
      def self.join_values(verb, time, headers, conon_headers, conon_resource)
        [
          verb,
          headers['Content-MD5'].to_s.strip,
          headers['Content-Type'].to_s.strip,
          time,
          conon_headers
        ].join("\n") + conon_resource
      end

      # @!visibility private
      def self.signature(secret_key, content_string)
        utf8_string = content_string.force_encoding('utf-8')
        Base64.encode64(
          OpenSSL::HMAC.digest(
            OpenSSL::Digest::SHA1.new,
            secret_key,
            utf8_string
          )
        )
      end

      # @!visibility private
      def self.get_cononicalized_odps_headers(headers)
        odps_headers = (headers || {}).select do |key, _|
          key.to_s.downcase.start_with?('x-odps-')
        end
        return if odps_headers.empty?

        odps_headers.keys.sort.map do |key|
          "#{key.downcase}:#{odps_headers[key]}"
        end.join("\n") + "\n"
      end

      # @!visibility private
      def self.get_cononicalized_resource(path, query)
        conon_resource = path
        return conon_resource if query.nil? || query.empty?

        Utils.stringify_keys!(query)

        query_str = query.keys.sort.map { |k| "#{k}=#{query[k]}" }.join('&')

        query_str.empty? ? conon_resource : conon_resource + '?' + query_str
      end
    end
  end
end
