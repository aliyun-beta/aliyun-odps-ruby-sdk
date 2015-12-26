require 'test_helper'

describe Aliyun::Odps::Client::Functions do
  let(:endpoint) { Aliyun::Odps.config.endpoint }
  let(:project_name) { 'mock_project_name' }
  let(:project) { Aliyun::Odps::Struct::Project.new(name: project_name, client: Aliyun::Odps::Client.instance) }

  describe "list functions" do
    it "should return list object" do
      query = { name: 'function1', owner: 'ownername', maxitems: 1, marker: 'fdsafdafdaeegfdsg' }
      stub_get_request("#{endpoint}/projects/#{project_name}/registration/functions", 'functions/list1.xml', query: query)

      obj = project.functions.list(query)
      assert_kind_of(Aliyun::Odps::List, obj)
      assert_equal('dsdhfdasjfljdafyiadcnajkfdlkjalf', obj.marker)
      assert_equal(1, obj.max_items)
    end

    it "should raise RequestError" do
      stub_fail_request(:get, "#{endpoint}/projects/#{project_name}/registration/functions")
      assert_raises(Aliyun::Odps::RequestError) { assert_kind_of Array, project.functions.list }
    end
  end

  describe "create" do
    it "should create function" do
      resource = Aliyun::Odps::Struct::Resource.new(name: 'Extract_Name.py')
      args = ['Extract_Name', 'ExtractName', [resource]]
      stub_post_request(
        "#{endpoint}/projects/#{project_name}/registration/functions", '', request_body: 'functions/create.xml', response_headers: { Location: "#{endpoint}/projects/test_project/registration/functions/Extract_Name" })
      assert_kind_of(String, project.functions.create(*args))
    end

    it "should raise RequestError" do
      stub_fail_request(:post, %r[/projects/#{project_name}/registration/functions])
      resource = Aliyun::Odps::Struct::Resource.new(name: 'function1')
      assert_raises(Aliyun::Odps::RequestError) { assert project.functions.create('functio1', 'functions/1.py', [resource]) }
    end
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
