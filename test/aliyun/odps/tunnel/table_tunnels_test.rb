require 'test_helper'

describe Aliyun::Odps::TableTunnels do
  let(:endpoint) { 'http://mock-dt.odps.aliyun.com' }
  let(:project_name) { 'mock_project_name' }
  let(:project) { Aliyun::Odps.project(project_name) }

  before do
    Aliyun::Odps::TunnelRouter.stubs(:get_tunnel_endpoint).returns(endpoint)
  end

  after do
    Aliyun::Odps::TunnelRouter.unstub(:get_tunnel_endpoint)
  end

  describe 'init download session' do
    it 'should init new download session' do
      stub_client_request(
        :post,
        "#{endpoint}/projects/#{project_name}/tables/table_name",
        {
          query: {
            downloads: true
          }
        },
        headers: {
          content_type: 'application/json'
        },
        file_path: 'table_tunnel/download_sessions/init.json'
      )

      obj = project.table_tunnels.init_download_session('table_name')

      assert_equal('table_name', obj.table_name)
      assert_equal(project, obj.project)
      assert_equal('201512111509369592b70a007a6c42', obj.download_id)
      assert_equal(10, obj.record_count)
    end

    it 'should raise RequestError' do
      stub_fail_request(
        :post,
        %r{/projects/#{project_name}/tables/table_name},
        {},
        file_path: 'tunnel_error.json',
        headers: { content_type: 'application/json' }
      )
      assert_raises(Aliyun::Odps::RequestError) do
        obj = project.table_tunnels.init_download_session('table_name')
        assert_kind_of(Aliyun::Odps::DownloadSession, obj)
      end
    end
  end

  describe 'init upload session' do
    it 'should init new upload session' do
      stub_client_request(
        :post,
        "#{endpoint}/projects/#{project_name}/tables/table_name",
        {
          query: {
            uploads: true
          },
          headers: {
            'x-odps-tunnel-version' => '4'
          }
        },
        headers: {
          content_type: 'application/json'
        },
        file_path: 'table_tunnel/upload_sessions/init.json'
      )

      obj = project.table_tunnels.init_upload_session('table_name')

      assert_kind_of(Aliyun::Odps::UploadSession, obj)
      assert_equal('table_name', obj.table_name)
      assert_equal('201512111331099692b70a0079c5f2', obj.upload_id)
      assert_equal('normal', obj.status)
      assert_equal(project, obj.project)
    end

    it 'should raise RequestError' do
      stub_fail_request(
        :post,
        %r{/projects/#{project_name}/tables/table_name},
        {},
        file_path: 'tunnel_error.json',
        headers: { content_type: 'application/json' }
      )
      assert_raises(Aliyun::Odps::RequestError) do
        project.table_tunnels.init_upload_session('table_name')
      end
    end
  end
end
