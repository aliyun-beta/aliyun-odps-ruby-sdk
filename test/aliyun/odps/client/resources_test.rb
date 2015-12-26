require 'test_helper'

describe Aliyun::Odps::Client::Resources do

  it "should should list resources" do
    p = Aliyun::Odps::Struct::Project.new(name: 'odps_sdk_demo', client: Aliyun::Odps::Client.instance)
    assert_kind_of Array, p.resources.list
  end
end
