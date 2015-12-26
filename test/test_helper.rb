$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'aliyun/odps'

require 'minitest/autorun'
require 'webmock/minitest'

Aliyun::Odps.configure do |config|
  config.access_key = ENV['ALIYUN_ACCESS_KEY']
  config.secret_key = ENV['ALIYUN_SECRET_KEY']
  config.endpoint = "http://service.odps.aliyun.com/api"
end

def stub_get_request(path, file_path, options = {})
  stub_client_request(:get, path, file_path, options)
end

def stub_put_request(path, file_path, options = {})
  stub_client_request(:put, path, file_path, options)
end

def stub_post_request(path, file_path, options = {})
  stub_client_request(:post, path, file_path, options)
end

def stub_delete_request(path, file_path, options = {})
  stub_client_request(:delete, path, file_path, options)
end

def stub_head_request(path, file_path, options = {})
  stub_client_request(:head, path, file_path, options)
end

def stub_client_request(verb, path, file_path, options = {})
  request_hash = {
    headers: {
      'Authorization' => /ODPS #{Aliyun::Odps.config.access_key}:\S*/
    }
  }
  request_hash.merge!(query: options[:query]) if options.key?(:query)
  request_hash[:headers].merge!(options[:headers]) if options.key?(:headers)
  request_hash.merge!(body: File.read(fixture_path(options[:request_body])).split("\n").map(&:strip).join) if options.key?(:request_body)

  response_hash = {
    status: options[:status] || 200,
    headers: {
      content_type: 'application/xml'
    }
  }
  response_hash[:headers].merge!(options[:response_headers]) if options.key?(:response_headers)
  response_hash.merge!(body: File.new(fixture_path(file_path))) unless file_path.empty?

  stub_request(verb, path).with(request_hash).to_return(response_hash)
end

def fixture_path(path)
  File.join(File.dirname(__FILE__), 'fixtures', path)
end

def stub_fail_request(verb, path)
  stub_request(verb, path).to_return(status: 400, body: File.new(fixture_path('test_error.xml')), headers: { content_type: 'application/xml' })
end
