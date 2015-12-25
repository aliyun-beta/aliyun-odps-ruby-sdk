$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'aliyun/odps'

require 'minitest/autorun'


Aliyun::Odps.configure do |config|
  config.access_key = 'ilowzBTRmVJb5CUr'
  config.secret_key = 'IlWd7Jcsls43DQjX5OXyemmRf1HyPN'
  config.end_point = 'http://service.odps.aliyun.com/api'
end