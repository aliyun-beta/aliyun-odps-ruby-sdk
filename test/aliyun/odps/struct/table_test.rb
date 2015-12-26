require 'test_helper'

describe Aliyun::Odps::Struct::Table do
  let(:project_name) { 'mock_project_name' }
  let(:project) { Aliyun::Odps::Struct::Project.new(name: project_name, client: Aliyun::Odps::Client.instance) }
  let(:table) { Aliyun::Odps::Struct::Table.new(name: 'table1', project: project, client: Aliyun::Odps::Client.instance) }

  it "should get partitions information" do
    stub_fail_request(:get, %r[/projects/#{project_name}/tables/table1])
    assert_raises(Aliyun::Odps::RequestError) { assert_kind_of Array, table.partitions }
  end
end
