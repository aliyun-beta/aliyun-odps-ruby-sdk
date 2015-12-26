require 'test_helper'

describe Aliyun::Odps::Client::Functions do
  let(:project_name) { 'mock_project_name' }
  let(:project) { Aliyun::Odps::Struct::Project.new(name: project_name, client: Aliyun::Odps::Client.instance) }

  it "should list functions" do
    stub_fail_request(:get, %r[/projects/#{project_name}/registration/functions])
    assert_raises(Aliyun::Odps::RequestError) { assert_kind_of Array, project.functions.list }
  end

  it "should create new function" do
    stub_fail_request(:post, %r[/projects/#{project_name}/registration/functions])
    resource = Aliyun::Odps::Struct::Resource.new(name: 'function1')
    assert_raises(Aliyun::Odps::RequestError) { assert project.functions.create('functio1', 'functions/1.py', [resource]) }
  end

  it "should update exist function" do
    stub_fail_request(:put, %r[/projects/#{project_name}/registration/functions/function1])
    resource = Aliyun::Odps::Struct::Resource.new(name: 'function1')
    assert_raises(Aliyun::Odps::RequestError) { assert project.functions.update('function1', 'functions/2.py', [resource]) }
  end

  it "should delete exist function" do
    stub_fail_request(:delete, %r[/projects/#{project_name}/registration/functions/function1])
    assert_raises(Aliyun::Odps::RequestError) { assert project.functions.delete('function1') }
  end

end
