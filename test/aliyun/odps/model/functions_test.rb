require 'test_helper'

describe Aliyun::Odps::Functions do
  describe 'list functions' do
    it 'should return list object' do
      query = { name: 'function1', owner: 'ownername', maxitems: 1, marker: 'fdsafdafdaeegfdsg' }
      stub_client_request(
        :get,
        "#{endpoint}/projects/#{project_name}/registration/functions",
        {
          query: query
        },
        file_path: 'functions/list.xml',
        headers: {
          content_type: 'application/xml'
        }
      )

      obj = project.functions.list(query)
      assert_kind_of(Aliyun::Odps::List, obj)
      assert_equal('dsdhfdasjfljdafyiadcnajkfdlkjalf', obj.marker)
      assert_equal(1, obj.max_items)
    end

    it 'should raise RequestError' do
      stub_fail_request(
        :get,
        "#{endpoint}/projects/#{project_name}/registration/functions"
      )
      assert_raises(Aliyun::Odps::RequestError) do
        assert_kind_of(Array, project.functions.list)
      end
    end
  end

  describe 'create' do
    it 'should create function' do
      location = "#{endpoint}/projects/test_project/registration/functions/Extract_Name"
      resource = Aliyun::Odps::Resource.new(name: 'Extract_Name.py')
      args = ['Extract_Name', 'ExtractName', [resource]]
      stub_client_request(
        :post,
        "#{endpoint}/projects/#{project_name}/registration/functions",
        {
          file_path: 'functions/create.xml'
        },
        headers: {
          Location: location
        }
      )

      obj = project.functions.create(*args)
      assert_kind_of(Aliyun::Odps::Function, obj)
      assert_equal(location, obj.location)
      assert_equal('Extract_Name', obj.name)
      assert_equal('ExtractName', obj.class_type)
    end

    it 'should raise RequestError' do
      stub_fail_request(:post, %r{/projects/#{project_name}/registration/functions})
      resource = Aliyun::Odps::Resource.new(name: 'function1')
      assert_raises(Aliyun::Odps::RequestError) do
        assert(
          project.functions.create('functio1', 'functions/1.py', [resource]),
          'should create function'
        )
      end
    end
  end

  describe 'update' do
    it 'should update exist function' do
      resource = Aliyun::Odps::Resource.new(name: 'Extract_Name.py')
      args = ['Extract_Name', 'ExtractName2', [resource]]
      stub_client_request(
        :put,
        "#{endpoint}/projects/#{project_name}/registration/functions/Extract_Name",
        file_path: 'functions/update.xml'
      )
      assert(project.functions.update(*args), 'update success')
    end

    it 'should raise RequestError' do
      stub_fail_request(:put, %r{/projects/#{project_name}/registration/functions/function1})
      resource = Aliyun::Odps::Resource.new(name: 'function1')
      assert_raises(Aliyun::Odps::RequestError) do
        assert(
          project.functions.update('function1', 'functions/2.py', [resource]),
          'should update function success'
        )
      end
    end
  end

  describe 'delete' do
    it 'should delete function' do
      stub_client_request(
        :delete,
        "#{endpoint}/projects/#{project_name}/registration/functions/function1"
      )
      assert(project.functions.delete('function1'), 'delete function success')
    end

    it 'should raise RequestError' do
      stub_fail_request(:delete, %r{/projects/#{project_name}/registration/functions/function1})
      assert_raises(Aliyun::Odps::RequestError) do
        assert(project.functions.delete('function1'), 'should delete function')
      end
    end
  end
end
