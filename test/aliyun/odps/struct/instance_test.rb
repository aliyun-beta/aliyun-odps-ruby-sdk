require 'test_helper'

describe Aliyun::Odps::Struct::Instance do
  let(:project_name) { 'mock_project_name' }
  let(:project) { Aliyun::Odps::Struct::Project.new(name: project_name, client: Aliyun::Odps::Client.instance) }
  let(:instance) { Aliyun::Odps::Struct::Instance.new(name: 'instance_name', project: project, client: Aliyun::Odps::Client.instance) }

  describe "task_detail" do
    it "should get task detail information" do
      stub_client_request(
        :get,
        "#{endpoint}/projects/#{project_name}/instances/#{instance.name}",
        {
          query: {
            instancedetail: true,
            taskname: 'task_name'
          }
        },
        {
          file_path: 'instance/task_detail.json',
          headers: {
            content_type: 'application/json'
          }
        }
      )

      obj = instance.task_detail('task_name')

      assert_kind_of(Hash, obj)
    end

    it "should raise RequestError" do
      stub_fail_request(:get, %r[/projects/#{project_name}/instances/instance_name])
      assert_raises(Aliyun::Odps::RequestError) { assert_kind_of Hash, instance.task_detail('task_name') }
    end
  end

  describe "task_progress" do
    it "should get task progress information" do
      stub_client_request(
        :get,
        "#{endpoint}/projects/#{project_name}/instances/instance_name",
        {
          query: {
            instanceprogress: true,
            taskname: 'task_name'
          }
        },
        {
          file_path: 'instance/task_progress.xml',
          headers: {
            content_type: 'application/xml'
          }
        }
      )

      obj = instance.task_progress('task_name')

      assert_kind_of(Hash, obj)
    end

    it "should raise RequestError" do
      stub_fail_request(:get, %r[/projects/#{project_name}/instances/instance_name])
      assert_raises(Aliyun::Odps::RequestError) { assert_kind_of Hash, instance.task_progress('task_name') }
    end
  end

  describe "task_summary" do
    it "should get task summary information" do
      stub_client_request(
        :get,
        "#{endpoint}/projects/#{project_name}/instances/instance_name",
        {
          query: {
            instancesummary: true,
            taskname: 'task_name'
          }
        },
        {
          file_path: 'instance/task_summary.json',
          headers: {
            content_type: 'application/json'
          }
        }
      )

      obj = instance.task_summary('task_name')

      assert_kind_of(Hash, obj)
    end

    it "should raise RequestError" do
      stub_fail_request(:get, %r[/projects/#{project_name}/instances/instance_name])
      assert_raises(Aliyun::Odps::RequestError) { assert_kind_of Hash, instance.task_summary('task_name') }
    end
  end

  describe "list_tasks" do
    it "should get tasks" do
      stub_client_request(
        :get,
        "#{endpoint}/projects/#{project_name}/instances/instance_name",
        {
          query: {
            taskstatus: true
          }
        },
        {
          file_path: 'instance/tasks.xml',
          headers: {
            content_type: 'application/xml'
          }
        }
      )

      obj = instance.list_tasks
      assert_kind_of(Array, obj)
    end

    it "should raise RequestError" do
      stub_fail_request(:get, %r[/projects/#{project_name}/instances/instance_name])
      assert_raises(Aliyun::Odps::RequestError) { assert_kind_of Array, instance.list_tasks }
    end
  end

  describe "terminate" do
    it "should terminate instance" do
      stub_client_request(
        :put,
        "#{endpoint}/projects/#{project_name}/instances/instance_name",
        {
          file_path: 'instance/terminate.xml'
        }
      )

      assert(instance.terminate, 'should terminate success')
    end

    it "should raise RequestError" do
      stub_fail_request(:put, %r[/projects/#{project_name}/instances/instance_name])
      assert_raises(Aliyun::Odps::RequestError) { assert instance.terminate }
    end
  end

end
