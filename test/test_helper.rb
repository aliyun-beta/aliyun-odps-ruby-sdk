$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'aliyun/odps'

require 'minitest/autorun'
require 'webmock/minitest'

Aliyun::Odps.configure do |config|
  config.access_key = 'ilowzBTRmVJb5CUr'
  config.secret_key = 'IlWd7Jcsls43DQjX5OXyemmRf1HyPN'
  config.endpoint = 'http://service.odps.aliyun.com/api'
end

def fixture_path(path)
  File.join(File.dirname(__FILE__), 'fixtures', path)
end

def stub_fail_request(verb, path)
  stub_request(verb, path).to_return(status: 400, body: File.new(fixture_path('test_error.xml')), headers: { content_type: 'application/xml' })
end
