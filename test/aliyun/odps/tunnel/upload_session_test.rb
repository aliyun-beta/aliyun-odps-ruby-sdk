require 'test_helper'

describe Aliyun::Odps::UploadSession do
  let(:endpoint) { 'http://mock-dt.odps.aliyun.com' }
  let(:project_name) { 'mock_project_name' }
  let(:project) { Aliyun::Odps.project(project_name) }
  let(:upload_session) do
    Aliyun::Odps::UploadSession.new(
      table_name: 'table1',
      upload_id: '1122wwssddd33222',
      client: project.table_tunnels.client,
      project: project
    )
  end

  before do
    Aliyun::Odps::TunnelRouter.stubs(:get_tunnel_endpoint).returns(endpoint)
  end

  after do
    Aliyun::Odps::TunnelRouter.unstub(:get_tunnel_endpoint)
  end

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

      assert(
        upload_session.upload(1, "Content", tunnel_version: '2.0', encoding: 'Gzip'),
        "update should success"
      )
    end

    it "should raise RequestError" do
      stub_fail_request(
        :put,
        %r[/projects/#{project_name}/tables/table1],
        {},
        {
          file_path: 'tunnel_error.json',
          headers: { content_type: 'application/json' }
        }
      )
      assert_raises(Aliyun::Odps::RequestError) do
        assert(upload_session.upload(100, "Hello"))
      end
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
      stub_fail_request(
        :get,
        %r[/projects/#{project_name}/tables/table1],
        {},
        {
          file_path: 'tunnel_error.json',
          headers: { content_type: 'application/json' }
        }
      )

      assert_raises(Aliyun::Odps::RequestError) do
        assert_kind_of(Hash, upload_session.get_status)
      end
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
      assert(
        upload_session.complete(tunnel_version: '2.0'),
        "should complete success"
      )
    end

    it "should raise RequestError" do
      stub_fail_request(
        :post,
        %r[/projects/#{project_name}/tables/table1],
        {},
        {
          file_path: 'tunnel_error.json',
          headers: { content_type: 'application/json' }
        }
      )
      assert_raises(Aliyun::Odps::RequestError) do
        assert(upload_session.complete, "should complete success")
      end
    end
  end


end
