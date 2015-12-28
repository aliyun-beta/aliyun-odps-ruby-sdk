require 'test_helper'

describe Aliyun::Odps::Clients::DownloadSessions do
  let(:project_name) { 'mock_project_name' }
  let(:project) { Aliyun::Odps::Project.new(name: project_name) }

  describe "init" do
    it "should init new download session" do
      stub_client_request(
        :post,
        "#{endpoint}/projects/#{project_name}/tables/table_name",
        {
          query: {
            downloads: true
          }
        },
        {
          headers: {
            content_type: 'application/json'
          },
          file_path: 'table_tunnel/download_sessions/init.json'
        }
      )

      obj = project.table_tunnels.download_sessions.init('table_name')

      assert_equal('table_name', obj.table_name)
      assert_equal(project, obj.project)
      assert_equal(project.client, obj.client)
      assert_equal("201512111509369592b70a007a6c42", obj.download_id)
      assert_equal(10, obj.record_count)
    end

    it "should raise RequestError" do
      stub_fail_request(:post, %r[/projects/#{project_name}/tables/table_name], {}, file_path: 'tunnel_error.json', headers: { content_type: 'application/json' })
      assert_raises(Aliyun::Odps::RequestError) { assert_kind_of Aliyun::Odps::Struct::DownloadSession, project.table_tunnels.download_sessions.init('table_name') }
    end

  end

end
