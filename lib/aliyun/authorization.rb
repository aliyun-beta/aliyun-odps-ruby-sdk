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

      def self.concat_content_string(verb, time, options = {})
        headers = options.fetch(:headers, {})

        conon_headers = get_cononicalized_oss_headers(headers)
        conon_resource = get_cononicalized_resource(
          *options.values_at(:bucket, :key, :query)
        )

        join_values(verb, time, headers, conon_headers, conon_resource)
      end

      def self.join_values(verb, time, headers, conon_headers, conon_resource)
        [
          verb,
          headers['Content-MD5'].to_s.strip,
          headers['Content-Type'].to_s.strip,
          time,
          conon_headers
        ].join("\n") + conon_resource
      end

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

      def self.get_cononicalized_oss_headers(headers)
        oss_headers = (headers || {}).select do |key, _|
          key.to_s.downcase.start_with?('x-oss-')
        end
        return if oss_headers.empty?

        oss_headers.keys.sort.map do |key|
          "#{key.downcase}:#{oss_headers[key]}"
        end.join("\n") + "\n"
      end

      def self.get_cononicalized_resource(bucket, key, query)
        conon_resource = '/'
        conon_resource += "#{bucket}/" if bucket
        conon_resource += key if key
        return conon_resource if query.nil? || query.empty?

        query_str = query.keys.select { |k| OVERRIDE_RESPONSE_LIST.include?(k) }
                    .sort.map { |k| "#{k}=#{query[k]}" }.join('&')

        query_str.empty? ? conon_resource : conon_resource + '?' + query_str
      end
    end
  end
end
