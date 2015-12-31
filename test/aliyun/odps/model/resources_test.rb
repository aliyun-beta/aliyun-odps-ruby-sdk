require 'test_helper'

describe Aliyun::Odps::Resources do
  describe 'list' do
    it 'should list resources' do
      query = { maxitems: 3 }
      stub_client_request(
        :get,
        "#{endpoint}/projects/#{project_name}/resources",
        {
          query: query
        },
        file_path: 'resources/list.xml',
        headers: {
          content_type: 'application/xml'
        }
      )

      obj = project.resources.list(query)

      assert_kind_of(Aliyun::Odps::List, obj)
      assert_equal(nil, obj.marker)
      assert_equal(3, obj.max_items)
    end

    it 'should raise RequestError' do
      stub_fail_request(:get, %r{/projects/#{project_name}/resources})
      assert_raises(Aliyun::Odps::RequestError) { project.resources.list }
    end
  end

  describe 'get' do
    it 'should get resource' do
      stub_client_request(
        :get,
        "#{endpoint}/projects/#{project_name}/resources/resource_name",
        {},
        headers: {
          'x-odps-resource-name' => 'resource_name',
          'x-odps-updator' => '',
          'x-odps-owner' => 'ALIYUN$odpstest1@aliyun.com',
          'x-odps-comment' => '',
          'Last-Modified' => 'Wed, 09 Dec 2015 19:01:41 GMT',
          'x-odps-creation-time' => 'Wed, 09 Dec 2015 19:01:41 GMT',
          'x-odps-resource-size' => '53660',
          'x-odps-resource-type' => 'jar'
        },
        file_path: 'resources/get.txt'
      )

      obj = project.resources.get('resource_name')

      assert_kind_of(Aliyun::Odps::Resource, obj)
      assert_equal('resource_name', obj.name)
      assert_equal('', obj.last_updator)
      assert_equal('ALIYUN$odpstest1@aliyun.com', obj.owner)
      assert_equal('', obj.comment)
      assert_equal(DateTime.parse('Wed, 09 Dec 2015 19:01:41 GMT'), obj.last_modified_time)
      assert_equal(DateTime.parse('Wed, 09 Dec 2015 19:01:41 GMT'), obj.creation_time)
      assert_equal(53_660, obj.resource_size)
      assert_equal('jar', obj.resource_type)
      assert_equal("content of resource.jar\n", obj.content)
    end

    it 'should raise RequestError' do
      stub_fail_request(:get, %r{/projects/#{project_name}/resources/resource_name})
      assert_raises(Aliyun::Odps::RequestError) { project.resources.get('resource_name') }
    end
  end

  describe 'get meta' do
    it 'should get resource meta information' do
      stub_client_request(
        :head,
        "#{endpoint}/projects/#{project_name}/resources/resource_name",
        {},
        headers: {
          'x-odps-resource-name' => 'resource_name',
          'x-odps-updator' => '',
          'x-odps-owner' => 'ALIYUN$odpstest1@aliyun.com',
          'x-odps-comment' => '',
          'Last-Modified' => 'Wed, 09 Dec 2015 19:01:41 GMT',
          'x-odps-creation-time' => 'Wed, 09 Dec 2015 19:01:41 GMT',
          'x-odps-resource-size' => '53660',
          'x-odps-resource-type' => 'jar'
        }
      )

      obj = project.resources.get_meta('resource_name')

      assert_kind_of(Aliyun::Odps::Resource, obj)
      assert_equal('resource_name', obj.name)
      assert_equal('', obj.last_updator)
      assert_equal('ALIYUN$odpstest1@aliyun.com', obj.owner)
      assert_equal('', obj.comment)
      assert_equal(DateTime.parse('Wed, 09 Dec 2015 19:01:41 GMT'), obj.last_modified_time)
      assert_equal(DateTime.parse('Wed, 09 Dec 2015 19:01:41 GMT'), obj.creation_time)
      assert_equal(53_660, obj.resource_size)
      assert_equal('jar', obj.resource_type)
    end

    it 'should raise RequestError' do
      stub_fail_request(:head, %r{/projects/#{project_name}/resources/resource_name})
      assert_raises(Aliyun::Odps::RequestError) { project.resources.get_meta('resource_name') }
    end
  end

  describe 'create' do
    it 'should create new resource' do
      args = ['resource_name', 'py', comment: 'test comment', file: 'Hello']
      location = "#{endpoint}/projects/#{project_name}/resources/resource_name"
      stub_client_request(
        :post,
        "#{endpoint}/projects/#{project_name}/resources/",
        {
          headers: {
            'x-odps-resource-name' => 'resource_name',
            'x-odps-resource-type' => 'py',
            'x-odps-comment' => 'test comment'
          },
          body: 'Hello'
        },
        headers: {
          Location: location
        }
      )

      obj = project.resources.create(*args)

      assert_kind_of(Aliyun::Odps::Resource, obj)
      assert_equal('resource_name', obj.name)
      assert_equal('py', obj.resource_type)
      assert_equal('test comment', obj.comment)
      assert_equal(location, obj.location)
    end

    it 'should create new table resource' do
      args = ['resource_name', 'table', comment: 'test comment', table: "test_table partition=(part='part1')"]
      location = "#{endpoint}/projects/#{project_name}/resources/resource_name"
      stub_client_request(
        :post,
        "#{endpoint}/projects/#{project_name}/resources/",
        {
          headers: {
            'x-odps-resource-name' => 'resource_name',
            'x-odps-resource-type' => 'table',
            'x-odps-copy-table-source' => "test_table partition=(part='part1')",
            'x-odps-comment' => 'test comment'
          }
        },
        headers: {
          Location: location
        }
      )

      obj = project.resources.create(*args)

      assert_kind_of(Aliyun::Odps::Resource, obj)
      assert_equal('resource_name', obj.name)
      assert_equal('table', obj.resource_type)
      assert_equal('test comment', obj.comment)
      assert_equal(location, obj.location)
    end

    it 'should raise RequestError' do
      stub_fail_request(:post, %r{/projects/#{project_name}/resources/})
      assert_raises(Aliyun::Odps::RequestError) do
        project.resources.create('resource_name', 'py', file: 'Hello')
      end
    end

    it 'should raise ResourceMissingContentError' do
      error = assert_raises(Aliyun::Odps::ResourceMissingContentError) do
        project.resources.create('resource_name', 'py')
      end
      assert_equal("A Resource must exist file or table", error.message)
    end
  end

  describe 'update' do
    it 'should update exist resource' do
      args = ['resource_name', 'py', comment: 'test comment', file: 'Hello']
      location = "#{endpoint}/projects/#{project_name}/resources/resource_name"
      stub_client_request(
        :put,
        "#{endpoint}/projects/#{project_name}/resources/resource_name",
        {
          headers: {
            'x-odps-resource-name' => 'resource_name',
            'x-odps-resource-type' => 'py',
            'x-odps-comment' => 'test comment'
          },
          body: 'Hello'
        },
        headers: {
          Location: location
        }
      )

      assert(project.resources.update(*args), 'update success')
    end

    it 'should update exist table resource' do
      args = ['resource_name', 'table', comment: 'test comment', table: "test_table partition=(part='part1')"]
      location = "#{endpoint}/projects/#{project_name}/resources/resource_name"
      stub_client_request(
        :put,
        "#{endpoint}/projects/#{project_name}/resources/resource_name",
        {
          headers: {
            'x-odps-resource-name' => 'resource_name',
            'x-odps-resource-type' => 'table',
            'x-odps-copy-table-source' => "test_table partition=(part='part1')",
            'x-odps-comment' => 'test comment'
          }
        },
        headers: {
          Location: location
        }
      )

      assert(project.resources.update(*args), 'should update success')
    end

    it 'should raise RequestError' do
      stub_fail_request(:put, %r{/projects/#{project_name}/resources/resource_name})
      assert_raises(Aliyun::Odps::RequestError) do
        project.resources.update('resource_name', 'py', file: 'Hello')
      end
    end

    it 'should raise ResourceMissingContentError' do
      error = assert_raises(Aliyun::Odps::ResourceMissingContentError) do
        project.resources.update('resource_name', 'py')
      end
      assert_equal("A Resource must exist file or table", error.message)
    end
  end

  describe 'delete' do
    it 'should delete exist resource' do
      stub_client_request(
        :delete,
        "#{endpoint}/projects/#{project_name}/resources/resource_name"
      )
      assert(project.resources.delete('resource_name'), 'delete success')
    end

    it 'should raise RequestError' do
      stub_fail_request(:delete, %r{/projects/#{project_name}/resources/resource_name})
      assert_raises(Aliyun::Odps::RequestError) do
        project.resources.delete('resource_name')
      end
    end
  end
end
