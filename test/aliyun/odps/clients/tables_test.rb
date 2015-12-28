require 'test_helper'

describe Aliyun::Odps::Clients::Tables do
  let(:project_name) { 'mock_project_name' }
  let(:project) { Aliyun::Odps::Struct::Project.new(name: project_name, clients: Aliyun::Odps::Client.instance) }

  describe "list" do
    it "should list tables" do
      query = { maxitems: 2 }
      stub_client_request(
        :get,
        "#{endpoint}/projects/#{project_name}/tables",
        {
          query: query.merge( tables: true, expectmarker: true )
        },
        {
          file_path: 'tables/list.xml',
          headers: {
            content_type: 'application/xml'
          }
        }
      )

      obj = project.tables.list(query)

      assert_kind_of(Aliyun::Odps::List, obj)
      assert_equal(nil, obj.marker)
      assert_equal(2, obj.max_items)
    end

    it "should raise RequestError" do
      stub_fail_request(:get, %r[/projects/#{project_name}/tables])
      assert_raises(Aliyun::Odps::RequestError) { assert_kind_of Array, project.tables.list }
    end
  end

  describe "get" do
    it "should get table" do
      stub_client_request(
        :get,
        "#{endpoint}/projects/#{project_name}/tables/test_table",
        {},
          {
          file_path: 'tables/get.xml',
          headers: {
            'content_type' => 'application/xml',
            'x-odps-creation-time' => 'Wed, 09 Dec 2015 12:18:45 GMT',
            'Last-Modified' => 'Wed, 09 Dec 2015 12:18:46 GMT',
            'x-odps-owner' => 'ALIYUN$odpstest1@aliyun.com'
          }
        }
      )

      obj = project.tables.get("test_table")

      assert_kind_of(Aliyun::Odps::Struct::Table, obj)
      assert_equal('test_table', obj.name)
      assert_equal('029a5286716248ad92dde15d70060ec2', obj.table_id)
      assert_equal(nil, obj.comment)
      assert_equal(DateTime.parse('Wed, 09 Dec 2015 12:18:45 GMT'), obj.creation_time)
      assert_equal(DateTime.parse('Wed, 09 Dec 2015 12:18:46 GMT'), obj.last_modified)
      assert_equal('ALIYUN$odpstest1@aliyun.com', obj.owner)
      assert_equal({"format"=>"Json", "__content__"=>"{\"columns\": [{ \"comment\": \"\", \"label\": \"\", \"name\": \"name\", \"type\": \"string\"}, { \"comment\": \"\", \"label\": \"\", \"name\": \"nid\", \"type\": \"bigint\"}, { \"comment\": \"\", \"label\": \"\", \"name\": \"age\", \"type\": \"bigint\"}], \"comment\": \"\", \"createTime\": 1449663525, \"hubLifecycle\": -1, \"isVirtualView\": false, \"lastDDLTime\": 1449663525, \"lastModifiedTime\": 1449663526, \"lifecycle\": -1, \"owner\": \"ALIYUN$odpstest1@aliyun.com\", \"partitionKeys\": [], \"shardExist\": false, \"size\": 0, \"tableLabel\": \"\", \"tableName\": \"test_table\"}"}, obj.schema)
    end

    it "should raise RequestError" do
      stub_fail_request(:get, %r[/projects/#{project_name}/tables/table_name])
      assert_raises(Aliyun::Odps::RequestError) { assert_kind_of Aliyun::Odps::Struct::Table, project.tables.get("table_name") }
    end
  end

end
