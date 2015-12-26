require 'test_helper'

describe Aliyun::Odps::Struct::Instance do
  let(:project_name) { 'mock_project_name' }
  let(:project) { Aliyun::Odps::Struct::Project.new(name: project_name, client: Aliyun::Odps::Client.instance) }
  let(:instance) { Aliyun::Odps::Struct::Instance.new(name: 'instance_name', project: project, client: Aliyun::Odps::Client.instance) }

  it "should get task detail information" do
    stub_fail_request(:get, %r[/projects/#{project_name}/instances/instance_name])
    assert_raises(Aliyun::Odps::RequestError) { assert_kind_of Hash, instance.task_detail('task_name') }
  end

  it "should get task progress information" do
    stub_fail_request(:get, %r[/projects/#{project_name}/instances/instance_name])
    assert_raises(Aliyun::Odps::RequestError) { assert_kind_of Hash, instance.task_progress('task_name') }
  end

  it "should get task summary information" do
    stub_fail_request(:get, %r[/projects/#{project_name}/instances/instance_name])
    assert_raises(Aliyun::Odps::RequestError) { assert_kind_of Hash, instance.task_summary('task_name') }
  end

  it "should get tasks" do
    stub_fail_request(:get, %r[/projects/#{project_name}/instances/instance_name])
    assert_raises(Aliyun::Odps::RequestError) { assert_kind_of Array, instance.tasks }
  end

  it "should terminate instance" do
    stub_fail_request(:put, %r[/projects/#{project_name}/instances/instance_name])
    assert_raises(Aliyun::Odps::RequestError) { assert instance.terminate }
  end

end
