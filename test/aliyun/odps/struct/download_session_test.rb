require 'test_helper'

describe Aliyun::Odps::Struct::DownloadSession do
  let(:project_name) { 'mock_project_name' }
  let(:project) { Aliyun::Odps::Struct::Project.new(name: project_name, client: Aliyun::Odps::Client.instance) }
  let(:download_session) { Aliyun::Odps::Struct::DownloadSession.new(table_name: 'table1', download_id: '1122wwssddd33222', project: project, client: Aliyun::Odps::Client.instance) }

  describe "download" do
    it "should can download" do
      columns = "col1,col2,col3"
      rowrange = "(1,100)"
      partition_spec = "part=part1"
      stub_client_request(
        :get,
        "#{endpoint}/projects/#{project_name}/tables/table1",
        {
          query: {
            data: true,
            columns: columns,
            rowrange: rowrange,
            partition: partition_spec,
            downloadid: download_session.download_id,
          },
          headers: {
            'x-odps-tunnel-version' => '2.0',
            'Accept-Encoding' => 'Zlib'
          }
        },
        {
          body: "content"
        }
      )

      obj = download_session.download(
        rowrange,
        columns,
        partition_spec: partition_spec,
        tunnel_version: '2.0',
        encoding: 'Zlib'
      )

      assert_equal("content", obj)
    end

    it "should raise RequestError" do
      stub_fail_request(:get, %r[/projects/#{project_name}/tables/table1], {}, file_path: 'tunnel_error.json', headers: { content_type: 'application/json' })
      assert_raises(Aliyun::Odps::RequestError) { assert_kind_of String, download_session.download("(1,100)", "uuid,name") }
    end
  end


end
