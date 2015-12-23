require 'test_helper'

describe Aliyun::Odps::Client::Projects do
  it 'should list projects' do
    client = Aliyun::Odps::Client.new(
      'ilowzBTRmVJb5CUr',
      'IlWd7Jcsls43DQjX5OXyemmRf1HyPN',
      endpoint: 'http://service.odps.aliyun.com/api'
    )
    #assert client.projects.list, 'Should contain something'
  end
end
