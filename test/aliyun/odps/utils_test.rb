require 'test_helper'

describe Aliyun::Odps::Utils do
  it 'should return hex for md5' do
    assert_equal(
      'c8daa53c3ded42156e18c913ca37d974',
      Aliyun::Odps::Utils.md5_hexdigest("<?xml version=\"1.0\" encoding=\"UTF-8\"?><Project><Name>odps_sdk_demo</Name><Comment>Hello Demo</Comment></Project>")
    )
  end
end
