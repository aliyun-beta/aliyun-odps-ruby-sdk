if ENV['TESTLOCAL']
  require 'simplecov'
  SimpleCov.start
else
  require 'coveralls'
  Coveralls.wear!
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'aliyun/odps'

require 'minitest/autorun'
require 'webmock/minitest'
require 'mocha/test_unit'

Aliyun::Odps.configure do |config|
  config.access_key = ''
  config.secret_key = ''
  config.endpoint = 'http://service.odps.aliyun.com/api'
  config.project = 'mock_project_name'
end

def project_name
  Aliyun::Odps.config.project
end

def project
  Aliyun::Odps::Project.new(
    name: project_name,
    client: Aliyun::Odps::Client.new
  )
end

def endpoint
  Aliyun::Odps.config.endpoint
end

def stub_client_request(verb, path, request = {}, response = {})
  headers = {
    'Authorization' => /ODPS #{Aliyun::Odps.config.access_key}:\S*/
  }.merge(request[:headers] || {})
  request.merge!(headers: headers)
  request.merge!(body: File.read(fixture_path(request.delete(:file_path))).split("\n").map(&:strip).join) if request.key?(:file_path)

  status = response[:status] || 200
  response.merge!(status: status)
  response.merge!(body: File.new(fixture_path(response.delete(:file_path)))) if response.key?(:file_path)

  stub_request(verb, path).with(request).to_return(response)
end

def stub_fail_request(verb, path, request = {}, response = {})
  response.merge!(
    status: 400,
    body: File.new(fixture_path(response[:file_path] || 'test_error.xml')),
    headers: { content_type: response[:headers] && response[:headers][:content_type] || 'application/xml' }
  )
  stub_client_request(verb, path, request, response)
end

def fixture_path(path)
  File.join(File.dirname(__FILE__), 'fixtures', path)
end
