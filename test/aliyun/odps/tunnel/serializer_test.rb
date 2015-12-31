require 'test_helper'

describe Aliyun::Odps::Serializer do
  it 'should parse server response properly' do
    body = File.new(fixture_path('response.txt')).read
    assert_equal(
        [["test2"], ["test3"], ["test4"], ["test5"], ["test6"], ["test8"], ["Jack"], ["Smith"]],
      Aliyun::Odps::Serializer.parse(body)
    )
  end
end
