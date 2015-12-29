require 'test_helper'

describe Aliyun::Odps::Tables do
  let(:project_name) { 'mock_project_name' }
  let(:project) { Aliyun::Odps.project(project_name) }

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
      assert_raises(Aliyun::Odps::RequestError) { project.tables.list }
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

      assert_kind_of(Aliyun::Odps::Table, obj)
      assert_equal('test_table', obj.name)
      assert_equal('029a5286716248ad92dde15d70060ec2', obj.table_id)
      assert_equal(nil, obj.comment)
      assert_equal(DateTime.parse('Wed, 09 Dec 2015 12:18:45 GMT'), obj.creation_time)
      assert_equal(DateTime.parse('Wed, 09 Dec 2015 12:18:46 GMT'), obj.last_modified)
      assert_equal('ALIYUN$odpstest1@aliyun.com', obj.owner)
      assert_kind_of(Aliyun::Odps::TableSchema, obj.schema)
      assert_equal(3, obj.schema.columns.size)
    end

    it "should raise RequestError" do
      stub_fail_request(:get, %r[/projects/#{project_name}/tables/table_name])
      assert_raises(Aliyun::Odps::RequestError) { project.tables.get("table_name") }
    end
  end

  describe "create" do
    it "should create table" do
      Aliyun::Odps::Utils.stubs(:generate_uuid).returns('instance20151229111744707cc8')
      Aliyun::Odps::Instance.any_instance.stubs(:wait_for_terminated).returns(true)
      location = "#{endpoint}/projects/#{project_name}/instances/NewJobName"
      stub_client_request(
        :post,
        "#{endpoint}/projects/#{project_name}/instances",
        {
          file_path: 'tables/create.xml'
        },
        {
          headers: {
            Location: location
          }
        }
      )
      stub_client_request(
        :get,
        "#{endpoint}/projects/#{project_name}/instances/NewJobName",
        {
          query: {
            'taskstatus' => true
          }
        },
        {
          file_path: 'instances/status.xml'
        }
      )

      schema = Aliyun::Odps::TableSchema.new({
        columns: [{name: 'uuid', type: 'bigint', comment: 'major key'}],
        partitions: [{name: 'name', type: 'string'}, {name: 'name2', type: 'string', comment: 'test partition comment'}]
      })

      obj = project.tables.create('test_table1', schema, comment: 'sql comment')

      assert_kind_of(Aliyun::Odps::Table, obj)
    end
  end

  describe "delete" do
    it "should delete table" do
      Aliyun::Odps::Utils.stubs(:generate_uuid).returns('instance20151229111744707cc8')
      location = "#{endpoint}/projects/#{project_name}/instances/NewJobName"
      stub_client_request(
        :post,
        "#{endpoint}/projects/#{project_name}/instances",
        {
          file_path: 'tables/delete.xml'
        },
        {
          headers: {
            Location: location
          }
        }
      )

      assert(project.tables.delete('test_table1'), "delete table success")
    end
  end

end
