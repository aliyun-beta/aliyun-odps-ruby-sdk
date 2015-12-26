require 'test_helper'

describe Aliyun::Odps::TunnelRouter do
  let(:client) { Aliyun::Odps::Client.instance }


  it "should get tunnel endpoint" do
    WebMock.disable!
    assert_equal("http://dt.odps.aliyun.com", Aliyun::Odps::TunnelRouter.new(client).get_tunnel_endpoint('odps_sdk_demo'))
    WebMock.enable!
  end
end
