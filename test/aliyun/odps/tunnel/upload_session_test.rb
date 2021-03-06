# encoding: utf-8
require 'test_helper'

describe Aliyun::Odps::UploadSession do
  let(:endpoint) { 'http://mock-dt.odps.aliyun.com' }
  let(:upload_session) do
    Aliyun::Odps::UploadSession.new(
      table_name: 'table1',
      schema: { 'columns' => [{ 'name' => 'name', 'type' => 'string' }] },
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

  describe 'upload' do
    it 'should can upload' do
      stub_client_request(
        :put,
        "#{endpoint}/projects/#{project_name}/tables/table1",
        query: {
          'blockid' => 1,
          'uploadid' => upload_session.upload_id
        },
        headers: {
          'x-odps-tunnel-version' => '4'
        },
        body: "\n\aContent\x80\xC0\xFF\u007Fڻ\xAB\xD3\r\xF0\xFF\xFF\u007F\u0002\xF8\xFF\xFF\u007F\xB7\xE2\xD2\xE7\n"
      )

      assert(
        upload_session.upload(1, [['Content']]),
        'update should success'
      )
    end

    it 'should can upload with snappy encoding' do
      stub_client_request(
        :put,
        "#{endpoint}/projects/#{project_name}/tables/table1",
        query: {
          'blockid' => 1,
          'uploadid' => upload_session.upload_id
        },
        headers: {
          'x-odps-tunnel-version' => '4'
        },
        body: /sNaPpY/
      )

      assert(
        upload_session.upload(1, [['Content']], 'snappy'),
        'update should success'
      )
    end

    it 'should raise RequestError' do
      stub_fail_request(
        :put,
        %r{/projects/#{project_name}/tables/table1},
        {},
        file_path: 'tunnel_error.json',
        headers: { content_type: 'application/json' }
      )
      assert_raises(Aliyun::Odps::RequestError) do
        assert(upload_session.upload(100, [['Hello']]))
      end
    end
  end

  describe 'reload' do
    it 'should get new status' do
      stub_client_request(
        :get,
        "#{endpoint}/projects/#{project_name}/tables/table1",
        {
          query: {
            uploadid: upload_session.upload_id
          }
        },
        file_path: 'table_tunnel/upload_sessions/status.json',
        headers: {
          content_type: 'application/json'
        }
      )

      obj = upload_session.reload
      assert_kind_of(Aliyun::Odps::UploadSession, obj)
      assert_equal(1, obj.blocks.size)
      assert_kind_of(Aliyun::Odps::UploadBlock, obj.blocks[0])
      assert_equal(0, obj.blocks[0].block_id)
    end

    it 'should reload without content_type' do
      stub_client_request(
        :get,
        "#{endpoint}/projects/#{project_name}/tables/table1",
        {
          query: {
            uploadid: upload_session.upload_id
          }
        },
        file_path: 'table_tunnel/upload_sessions/status.json'
      )

      obj = upload_session.reload
      assert_kind_of(Aliyun::Odps::UploadSession, obj)
      assert_equal(1, obj.blocks.size)
      assert_kind_of(Aliyun::Odps::UploadBlock, obj.blocks[0])
      assert_equal(0, obj.blocks[0].block_id)
    end

    it 'should raise RequestError' do
      stub_fail_request(
        :get,
        %r{/projects/#{project_name}/tables/table1},
        {},
        file_path: 'tunnel_error.json',
        headers: { content_type: 'application/json' }
      )

      assert_raises(Aliyun::Odps::RequestError) { upload_session.reload }
    end
  end

  describe 'complete' do
    it 'should complete a upload session' do
      stub_client_request(
        :post,
        "#{endpoint}/projects/#{project_name}/tables/table1",
        query: {
          uploadid: upload_session.upload_id
        },
        headers: {
          'x-odps-tunnel-version' => '4'
        }
      )
      assert(upload_session.complete, 'should complete success')
    end

    it 'should raise RequestError' do
      stub_fail_request(
        :post,
        %r{/projects/#{project_name}/tables/table1},
        {},
        file_path: 'tunnel_error.json',
        headers: { content_type: 'application/json' }
      )
      assert_raises(Aliyun::Odps::RequestError) { upload_session.complete }
    end
  end

  describe 'list blocks' do
    it 'should list uploaded blocks' do
      upload_session.expects(:reload)
      upload_session.list_blocks
    end
  end
end
