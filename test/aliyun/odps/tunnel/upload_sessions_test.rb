require 'test_helper'

describe Aliyun::Odps::UploadSessions do
  let(:project_name) { 'mock_project_name' }
  let(:project) { Aliyun::Odps::Project.new(name: project_name) }

  describe "init" do
    it "should init upload session" do
      stub_client_request(
        :post,
        "#{endpoint}/projects/#{project_name}/tables/table_name",
        {
          query: {
            uploads: true
          },
          headers: {
            'x-odps-tunnel-version' => '2.0'
          }
        },
        {
          headers: {
            content_type: 'application/json'
          },
          file_path: 'table_tunnel/upload_sessions/init.json'
        }
      )

      obj = project.table_tunnels.upload_sessions.init('table_name', tunnel_version: '2.0')

      assert_kind_of(Aliyun::Odps::UploadSession, obj)
      assert_equal('table_name', obj.table_name)
      assert_equal("201512111331099692b70a0079c5f2", obj.upload_id)
      assert_equal('normal', obj.status)
      assert_equal(project, obj.project)
    end

    it "should raise RequestError" do
      stub_fail_request(:post, %r[/projects/#{project_name}/tables/table_name], {}, file_path: 'tunnel_error.json', headers: { content_type: 'application/json' })
      assert_raises(Aliyun::Odps::RequestError) { assert_kind_of Aliyun::Odps::UploadSession, project.table_tunnels.upload_sessions.init('table_name') }
    end
  end
end
