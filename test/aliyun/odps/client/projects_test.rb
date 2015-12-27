require 'test_helper'

describe Aliyun::Odps::Client::Projects do
  let(:project_service) { Aliyun::Odps::Client::ProjectsService.new(Aliyun::Odps::Client.instance) }

  describe "list" do
    it 'should list projects' do
    end

    it "should raise RequestError" do
      stub_fail_request(:get, %r[/projects])
      assert_raises(Aliyun::Odps::RequestError) { assert_kind_of Aliyun::Odps::List, project_service.list }
    end
  end

  describe "get" do

    it "should raise RequestError" do
      stub_fail_request(:get, %r[/projects/project_name])
      assert_raises(Aliyun::Odps::RequestError) { assert_kind_of Aliyun::Odps::Struct::Project, project_service.get('project_name') }
    end
  end

  describe "update" do
    it "should raise RequestError" do
      stub_fail_request(:put, %r[/projects/project_name])
      assert_raises(Aliyun::Odps::RequestError) { assert(project_service.update('project_name'), 'update success') }
    end
  end

end
