require 'test_helper'

describe Aliyun::Odps::DownloadSession do
  let(:endpoint) { 'http://mock-dt.odps.aliyun.com' }
  let(:download_session) do
    Aliyun::Odps::DownloadSession.new(
      table_name: 'table1',
      partition_spec: 'part=part1',
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
      columns = 'col1,col2,col3'
      rowrange = '(1,100)'
      stub_client_request(
        :get,
        "#{endpoint}/projects/#{project_name}/tables/table1",
        {
          query: {
            data: true,
            columns: columns,
            rowrange: rowrange,
            partition: download_session.partition_spec,
            downloadid: download_session.download_id
          },
          headers: {
            'x-odps-tunnel-version' => '4',
            'Accept-Encoding' => 'deflate'
          }
        },
        body: 'content'
      )

      obj = download_session.download(rowrange, columns, 'deflate')
      assert_equal('content', obj)
    end

    it 'should raise RequestError' do
      stub_fail_request(
        :get,
        %r{/projects/#{project_name}/tables/table1},
        {},
        file_path: 'tunnel_error.json',
        headers: { content_type: 'application/json' }
      )
      assert_raises(Aliyun::Odps::RequestError) { download_session.download('(1,100)', 'uuid,name') }
    end
  end
end
