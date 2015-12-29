require 'test_helper'

describe Aliyun::Odps::Model::Table do
  let(:project_name) { 'mock_project_name' }
  let(:project) { Aliyun::Odps::Model::Project.new(name: project_name) }
  let(:table) { Aliyun::Odps::Model::Table.new(name: 'table1', project: project) }

  describe "partitions" do
    it "should get partitions information" do
      query = { maxitems: 2, marker: 'cGFydDE9cGFydDEh' }
      stub_client_request(
        :get,
        "#{endpoint}/projects/#{project_name}/tables/table1",
        {
          query: {
            partitions: true,
            expectmarker: true
          }.merge(query)
        },
        {
          file_path: 'tables/partitions.xml',
          headers: {
            content_type: 'application/xml'
          }
        }
      )

      obj = table.list_partitions(query)

      assert_kind_of(Aliyun::Odps::List, obj)
      assert_equal(nil, obj.marker)
      assert_equal(2, obj.max_items)
      assert_equal([{"Name"=>"sale_date", "Value"=>"20150915"}, {"Name"=>"region", "Value"=>"USA"}], obj[0].column)
    end

    it "should raise RequestError" do
      stub_fail_request(:get, %r[/projects/#{project_name}/tables/table1])
      assert_raises(Aliyun::Odps::RequestError) { assert_kind_of Array, table.list_partitions }
    end
  end

  describe "create" do
    it "should generate correct sql" do
      table = Aliyun::Odps::Model::Table.new(
        name: 'test_table',
        project: project,
        schema: {
          columns: [{name: 'uuid', type: 'bigint', comment: 'major key'}],
          partitions: [{name: 'name', type: 'string'}, {name: 'name2', type: 'string', comment: 'test partition comment'}]
        })

      assert_equal("CREATE TABLE mock_project_name.`test_table` (`uuid` bigint COMMENT 'major key') PARTITIONED BY (`name` string, `name2` string COMMENT 'test partition comment');", table.generate_create_sql)
    end

    it "should generate correct sql with schema object" do
      schema = Aliyun::Odps::Model::TableSchema.new({
        columns: [{name: 'uuid', type: 'bigint', comment: 'major key'}],
        partitions: [{name: 'name', type: 'string'}, {name: 'name2', type: 'string', comment: 'test partition comment'}]
      })
      table = Aliyun::Odps::Model::Table.new(name: 'test_table', comment: 'table comment', project: project, schema: schema)

      assert_equal("CREATE TABLE mock_project_name.`test_table` (`uuid` bigint COMMENT 'major key') COMMENT 'table comment' PARTITIONED BY (`name` string, `name2` string COMMENT 'test partition comment');", table.generate_create_sql)
    end
  end

end
