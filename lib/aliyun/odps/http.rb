require 'httparty'
require 'addressable/uri'
require 'aliyun/odps/error'

module Aliyun
  module Odps
    class Http # nodoc
      attr_reader :access_key, :secret_key

      def initialize(access_key, secret_key, endpoint)
        @access_key = access_key
        @secret_key = secret_key
        @endpoint = endpoint
      end

      def get(uri, options = {})
        request('GET', uri, options)
      end

      def put(uri, options = {})
        headers = default_content_type.merge(options[:headers] || {})
        request('PUT', uri, options.merge(headers: headers))
      end

      def post(uri, options = {})
        headers = default_content_type.merge(options[:headers] || {})
        request('POST', uri, options.merge(headers: headers))
      end

      def delete(uri, options = {})
        headers = default_content_type.merge(options[:headers] || {})
        request('DELETE', uri, options.merge(headers: headers))
      end

      def options(uri, options = {})
        request('OPTIONS', uri, options)
      end

      def head(uri, options = {})
        request('HEAD', uri, options)
      end

      private

      def request(verb, resource, options = {})
        query = options.fetch(:query, {})
        headers = options.fetch(:headers, {})
        body = options.delete(:body)

        append_headers!(headers, verb, body, options.merge(path: resource))

        path = @endpoint + resource
        #options = { headers: headers, query: query, body: body, uri_adapter: Addressable::URI, http_proxyaddr: "127.0.0.1", http_proxyport: "8888" }
        options = { headers: headers, query: query, body: body, uri_adapter: Addressable::URI }
        p options

        wrap(HTTParty.__send__(verb.downcase, path, options))
      end

      def wrap(response)
        case response.code
        when 200..299
          response
        else
          fail RequestError, response
        end
      end

      def append_headers!(headers, verb, body, options)
        append_default_headers!(headers)
        append_body_headers!(headers, body)
        append_authorization_headers!(headers, verb, options)
      end

      def append_default_headers!(headers)
        headers.merge!(default_headers)
      end

      def append_body_headers!(headers, body)
        return headers unless body

        unless headers.key?('Content-MD5')
          headers.merge!('Content-MD5' => Utils.md5_hexdigest(body))
        end

        return if headers.key?('Content-Length')
        headers.merge!('Content-Length' => Utils.content_size(body).to_s)
      end

      def append_authorization_headers!(headers, verb, options)
        auth_key = get_auth_key(
          options.merge(verb: verb, headers: headers, date: headers['Date'])
        )
        headers.merge!('Authorization' => auth_key)
      end

      def get_auth_key(options)
        Authorization.get_authorization(access_key, secret_key, options)
      end

      def default_headers
        {
          'User-Agent' => user_agent,
          'Date' => Time.now.utc.strftime('%a, %d %b %Y %H:%M:%S GMT')
        }
      end

      def default_content_type
        {
          'Content-Type' => 'application/xml'
        }
      end

      def user_agent
        "aliyun-odps-sdk-ruby/#{Aliyun::Odps::VERSION} " \
        "(#{RbConfig::CONFIG['host_os']} ruby-#{RbConfig::CONFIG['ruby_version']})"
      end
    end
  end
end
