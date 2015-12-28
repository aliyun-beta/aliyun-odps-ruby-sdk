require 'test_helper'

describe Aliyun::Odps::Model::UploadSession do
  let(:project_name) { 'mock_project_name' }
  let(:project) { Aliyun::Odps::Model::Project.new(name: project_name) }
  let(:upload_session) { Aliyun::Odps::Model::UploadSession.new(table_name: 'table1', upload_id: '1122wwssddd33222', project: project) }

  describe "upload" do
    it "should can upload" do
      stub_client_request(
        :put,
        "#{endpoint}/projects/#{project_name}/tables/table1",
        {
          query: {
            'blockid' => 1,
            'uploadid' => upload_session.upload_id
          },
          headers: {
            'x-odps-tunnel-version' => '2.0',
            'Content-Encoding' => 'Gzip'
          },
          body: "Content"
        }
      )

      assert(upload_session.upload(1, "Content", tunnel_version: '2.0', encoding: 'Gzip'), "update should success")
    end

    it "should raise RequestError" do
      stub_fail_request(:put, %r[/projects/#{project_name}/tables/table1], {}, file_path: 'tunnel_error.json', headers: { content_type: 'application/json' })
      assert_raises(Aliyun::Odps::RequestError) { assert upload_session.upload(100, "Hello") }
    end
  end

  describe "get status" do
    it "should view status" do
      stub_client_request(
        :get,
        "#{endpoint}/projects/#{project_name}/tables/table1",
        {
          query: {
            uploadid: upload_session.upload_id
          }
        },
        {
          file_path: 'table_tunnel/upload_sessions/status.json',
          headers: {
            content_type: 'application/json'
          }
        }
      )

      assert_kind_of(Hash, upload_session.get_status)
    end

    it "should view status without content_type" do
      stub_client_request(
        :get,
        "#{endpoint}/projects/#{project_name}/tables/table1",
        {
          query: {
            uploadid: upload_session.upload_id
          }
        },
        {
          file_path: 'table_tunnel/upload_sessions/status.json'
        }
      )

      assert_kind_of(Hash, upload_session.get_status)
    end

    it "should raise RequestError" do
      stub_fail_request(:get, %r[/projects/#{project_name}/tables/table1], {}, file_path: 'tunnel_error.json', headers: { content_type: 'application/json' })
      assert_raises(Aliyun::Odps::RequestError) { assert_kind_of Hash, upload_session.get_status }
    end
  end


  describe "complete" do
    it "should complete a upload session" do
      stub_client_request(
        :post,
        "#{endpoint}/projects/#{project_name}/tables/table1",
        {
          query: {
            uploadid: upload_session.upload_id
          },
          headers: {
            'x-odps-tunnel-version' => '2.0'
          }
        }
      )
      assert(upload_session.complete(tunnel_version: '2.0'), "should complete success")
    end

    it "should raise RequestError" do
      stub_fail_request(:post, %r[/projects/#{project_name}/tables/table1], {}, file_path: 'tunnel_error.json', headers: { content_type: 'application/json' })
      assert_raises(Aliyun::Odps::RequestError) { assert upload_session.complete }
    end
  end


end
