require 'test_helper'

describe Aliyun::Odps::TunnelRouter do
  let(:project_name) { 'mock_project' }
  let(:tunnel_server) { 'mock-dt.odps.aliyun.com' }
  let(:client) { Aliyun::Odps::Client.new }

  it "should get tunnel endpoint" do
    stub_client_request(
      :get,
      "#{endpoint}/projects/#{project_name}/tunnel",
      {
        query: {
          curr_project: project_name,
          service: true
        }
      },
      {
        body: tunnel_server,
        headers: {
          content_type: 'application/xml'
        }
      }
    )

    assert_equal(
      "http://#{tunnel_server}",
      Aliyun::Odps::TunnelRouter.get_tunnel_endpoint(client, project_name)
    )
  end

  it "should return nil when raise RequestError" do
    stub_fail_request(
      :get,
      "#{endpoint}/projects/#{project_name}/tunnel",
      {
        query: {
          curr_project: project_name,
          service: true
        }
      }
    )

    assert_nil(
      Aliyun::Odps::TunnelRouter.get_tunnel_endpoint(client, project_name)
    )
  end
end
