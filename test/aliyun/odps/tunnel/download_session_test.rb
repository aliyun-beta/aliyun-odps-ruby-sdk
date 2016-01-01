require 'test_helper'

describe Aliyun::Odps::DownloadSession do
  let(:endpoint) { 'http://mock-dt.odps.aliyun.com' }
  let(:download_session) do
    Aliyun::Odps::DownloadSession.new(
      table_name: 'table1',
      partition_spec: 'part=part1',
      schema: { 'columns' => [{ 'name' => 'name', 'type' => 'string' }] },
      download_id: '1122wwssddd33222',
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

  describe 'download' do
    it 'should can download' do
      columns = ['col1', 'col2', 'col3']
      rowrange = [1, 100]
      stub_client_request(
        :get,
        "#{endpoint}/projects/#{project_name}/tables/table1",
        {
          query: {
            data: true,
            columns: columns.join(','),
            rowrange: "(#{rowrange.join(',')})",
            partition: download_session.partition_spec,
            downloadid: download_session.download_id
          },
          headers: {
            'x-odps-tunnel-version' => '4'
          }
        },
        body: "\n\aContent\x80\xC0\xFF\u007Fڻ\xAB\xD3\r\xF0\xFF\xFF\u007F\u0002\xF8\xFF\xFF\u007F\xB7\xE2\xD2\xE7\n"
      )

      obj = download_session.download(*rowrange, columns)
      assert_equal([["Content"]], obj)
    end

    it 'should can download with snappy encoding' do
      skip("should can download with snappy encoding")
    end

    it 'should raise RequestError' do
      stub_fail_request(
        :get,
        %r{/projects/#{project_name}/tables/table1},
        {},
        file_path: 'tunnel_error.json',
        headers: { content_type: 'application/json' }
      )
      columns = ['col1', 'col2', 'col3']
      assert_raises(Aliyun::Odps::RequestError) { download_session.download(1, 100, columns) }
    end
  end
end
