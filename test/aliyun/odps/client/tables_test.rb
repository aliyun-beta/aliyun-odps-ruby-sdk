require 'test_helper'

describe Aliyun::Odps::Client::Tables do
  let(:project_name) { 'mock_project_name' }
  let(:project) { Aliyun::Odps::Struct::Project.new(name: project_name, client: Aliyun::Odps::Client.instance) }

  it "should list tables" do
    stub_fail_request(:get, %r[/projects/#{project_name}/tables])
    assert_raises(Aliyun::Odps::RequestError) { assert_kind_of Array, project.tables.list }
  end

  it "should get table" do
    stub_fail_request(:get, %r[/projects/#{project_name}/tables/table_name])
    assert_raises(Aliyun::Odps::RequestError) { assert_kind_of Aliyun::Odps::Struct::Table, project.tables.get("table_name") }
  end

end
