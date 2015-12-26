require 'test_helper'

describe Aliyun::Odps::Client::Resources do
  let(:project_name) { 'mock_project_name' }
  let(:project) { Aliyun::Odps::Struct::Project.new(name: project_name, client: Aliyun::Odps::Client.instance) }

  it "should list instances" do
    stub_fail_request(:get, %r[/projects/#{project_name}/instances])
    assert_raises(Aliyun::Odps::RequestError) { assert_kind_of Array, project.instances.list }
  end

  it "should create new instance" do
    stub_fail_request(:post, %r[/projects/#{project_name}/instances])
    task = Aliyun::Odps::Struct::InstanceTask.new(type: 'SQL', name: 'sql1', comment: 'test SQL', query: 'select * from table1 limit 1;')
    assert_raises(Aliyun::Odps::RequestError) { assert_kind_of String, project.instances.create('newinstance', 'Test Instance', 1, [task]) }
  end

  it "should view instance status" do
    stub_fail_request(:get, %r[/projects/#{project_name}/instances/newinstance])
    assert_raises(Aliyun::Odps::RequestError) { assert_kind_of Hash, project.instances.status('newinstance') }
  end

end
