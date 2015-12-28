require 'test_helper'

describe Aliyun::Odps::Clients::Resources do
  # let(:project_name) { 'mock_project_name' }
  # let(:project) { Aliyun::Odps::Struct::Project.new(name: project_name, clients: Aliyun::Odps::Client.instance) }
  #
  # it "should list resources" do
  #   stub_fail_request(:get, %r[/projects/#{project_name}/resources])
  #   assert_raises(Aliyun::Odps::RequestError) { assert_kind_of Array, project.resources.list }
  # end
  #
  # it "should get resource" do
  #   stub_fail_request(:get, %r[/projects/#{project_name}/resources/resource_name])
  #   assert_raises(Aliyun::Odps::RequestError) { assert_kind_of Aliyun::Odps::Struct::Resource, project.resources.get('resource_name') }
  # end
  #
  # it "should get resource meta information" do
  #   stub_fail_request(:head, %r[/projects/#{project_name}/resources/resource_name])
  #   assert_raises(Aliyun::Odps::RequestError) { assert_kind_of Aliyun::Odps::Struct::Resource, project.resources.get_meta('resource_name') }
  # end
  #
  # it "should create new resource" do
  #   stub_fail_request(:post, %r[/projects/#{project_name}/resources/])
  #   assert_raises(Aliyun::Odps::RequestError) { assert_kind_of String, project.resources.create('py', 'resource_name', file: 'Hello') }
  # end
  #
  # it "should update exist resource" do
  #   stub_fail_request(:put, %r[/projects/#{project_name}/resources/resource_name])
  #   assert_raises(Aliyun::Odps::RequestError) { assert project.resources.update('py', 'resource_name', file: 'Hello') }
  # end
  #
  # it "should delete exist resource" do
  #   stub_fail_request(:delete , %r[/projects/#{project_name}/resources/resource_name])
  #   assert_raises(Aliyun::Odps::RequestError) { assert project.resources.delete('resource_name') }
  # end
end
