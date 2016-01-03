require 'test_helper'

describe Aliyun::Odps::Resources do
  describe 'list instances' do
    it 'should return list object' do
      query = { maxitems: 3, status: 'Terminated' }
      stub_client_request(
        :get,
        "#{endpoint}/projects/#{project_name}/instances",
        {
          query: query
        },
        file_path: 'instances/list.xml',
        headers: {
          content_type: 'application/xml'
        }
      )

      list = project.instances.list(query)
      assert_kind_of(Aliyun::Odps::List, list)
      assert_equal('MjAxNTExMTAwMzA3MjIzODRnaGlzdDczOCo=', list.marker)
      assert_equal(3, list.max_items)
    end

    it 'should raise RequestError' do
      stub_fail_request(:get, %r{/projects/#{project_name}/instances})
      assert_raises(Aliyun::Odps::RequestError) do
        assert_kind_of(Array, project.instances.list)
      end
    end
  end

  describe 'create' do
    it 'should create new instance' do
      location = "#{endpoint}/projects/#{project_name}/instances/UUIDJobName"
      task = Aliyun::Odps::InstanceTask.new(
        type: 'SQL',
        name: 'SqlTask',
        comment: 'TaskComment',
        property: { 'key1' => 'value1' },
        query: 'SELECT * FROM test_table;'
      )
      args = [[task], name: 'JobName', comment: 'JobComment', priority: 1]
      stub_client_request(
        :post,
        "#{endpoint}/projects/#{project_name}/instances",
        {
          file_path: 'instances/create.xml'
        },
        headers: {
          Location: location
        }
      )

      instance = project.instances.create(*args)
      assert_kind_of(Aliyun::Odps::Instance, instance)
      assert_equal('UUIDJobName', instance.name)
      assert_equal(location, instance.location)
    end

    it 'should create new instance without task comment' do
      location = "#{endpoint}/projects/#{project_name}/instances/JobName"
      task = Aliyun::Odps::InstanceTask.new(type: 'SQL', name: 'SqlTask', query: 'SELECT * FROM test_table;')
      args = [[task], name: 'JobName', comment: 'JobComment', priority: 1]
      stub_client_request(
        :post,
        "#{endpoint}/projects/#{project_name}/instances",
        {
          file_path: 'instances/create2.xml'
        },
        headers: {
          Location: location
        }
      )

      instance = project.instances.create(*args)
      assert_kind_of(Aliyun::Odps::Instance, instance)
      assert_equal('JobName', instance.name)
      assert_equal(location, instance.location)
    end

    it 'should create new instance with invalid name' do
      task = Aliyun::Odps::InstanceTask.new(type: 'SQL', name: 'SqlTask', query: 'SELECT * FROM test_table;')
      args = [[task], name: '1invalidJobName', comment: 'JobComment', priority: 1]
      assert_raises(Aliyun::Odps::InstanceNameInvalidError) do
        project.instances.create(*args)
      end
    end

    it 'should create new instance with more than one task' do
      location = "#{endpoint}/projects/#{project_name}/instances/UUIDJobName"
      task1 = Aliyun::Odps::InstanceTask.new(
        type: 'SQL',
        name: 'SqlTask',
        comment: 'TaskComment',
        property: { 'key1' => 'value1' },
        query: 'SELECT * FROM test_table;'
      )
      task2 = Aliyun::Odps::InstanceTask.new(
        type: 'SQL',
        name: 'SqlTask2',
        comment: 'TaskComment2',
        property: { 'key1' => 'value1' },
        query: 'SELECT * FROM test_table;'
      )
      args = [[task1, task2], name: 'JobName', comment: 'JobComment', priority: 1]
      stub_client_request(
        :post,
        "#{endpoint}/projects/#{project_name}/instances",
        {
          file_path: 'instances/create3.xml'
        },
        headers: {
          Location: location
        }
      )

      instance = project.instances.create(*args)
      assert_kind_of(Aliyun::Odps::Instance, instance)
      assert_equal('UUIDJobName', instance.name)
      assert_equal(location, instance.location)
    end

    it 'should raise RequestError' do
      stub_fail_request(:post, %r{/projects/#{project_name}/instances})
      task = Aliyun::Odps::InstanceTask.new(
        type: 'SQL',
        name: 'sql1',
        comment: 'test SQL',
        query: 'select * from table1 limit 1;'
      )
      assert_raises(Aliyun::Odps::RequestError) do
        assert_kind_of(String, project.instances.create([task]))
      end
    end
  end

  describe 'status' do
    it 'should view instance status' do
      stub_client_request(
        :get,
        "#{endpoint}/projects/#{project_name}/instances/instancename",
        {},
        file_path: 'instances/status.xml',
        headers: {
          content_type: 'application/xml'
        }
      )
      assert_equal('Terminated', project.instances.status('instancename'))
    end

    it 'should raise RequestError' do
      stub_fail_request(:get, %r{/projects/#{project_name}/instances/newinstance})
      assert_raises(Aliyun::Odps::RequestError) do
        assert_kind_of(Hash, project.instances.status('newinstance'))
      end
    end
  end
end
