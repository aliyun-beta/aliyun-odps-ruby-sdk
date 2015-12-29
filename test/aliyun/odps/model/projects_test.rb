require 'test_helper'

describe Aliyun::Odps::Projects do
  let(:project_service) { Aliyun::Odps::Client.instance.projects }

  describe "list" do
    it 'should list projects' do
      query = { maxitems: 2 }
      stub_client_request(
        :get,
        "#{endpoint}/projects",
        {
          query: query
        },
        {
          file_path: 'projects/list.xml',
          headers: {
            content_type: 'application/xml'
          }
        }
      )

      obj = project_service.list(query)

      assert_kind_of(Aliyun::Odps::List, obj)
      assert_equal('YV8wOTEzMDIwMDQyX3N0Z18zNzEq', obj.marker)
      assert_equal(2, obj.max_items)
    end

    it "should raise RequestError" do
      stub_fail_request(:get, %r[/projects])
      assert_raises(Aliyun::Odps::RequestError) { assert_kind_of Aliyun::Odps::List, project_service.list }
    end
  end

  describe "get" do
    it "should get project" do
      stub_client_request(
        :get,
        "#{endpoint}/projects/project_name",
        {},
        {
          file_path: 'projects/get.xml',
          headers: {
            content_type: 'application/xml'
          }
        }
      )

      obj = project_service.get('project_name')

      assert_kind_of(Aliyun::Odps::Project, obj)
      assert_equal('test_project', obj.name)
      assert_equal('odps test project', obj.comment)
      assert_equal('AVAILABLE', obj.state)
      assert_equal('test_project', obj.project_group_name)
      assert_equal({"Cluster"=>[{"Name"=>"ODPS-STG", "QuotaID"=>"1"}, {"Name"=>"ODPS-STGCONTROL", "QuotaID"=>"1"}]}, obj.clusters)
      assert_equal("{}", obj.property)
      assert_equal({"Property"=>[{"Name"=>"READ_TABLE_MAX_ROW", "Value"=>"10000"}, {"Name"=>"odps.changelogs.ttl", "Value"=>"0"}]}, obj.properties)
    end

    it "should raise RequestError" do
      stub_fail_request(:get, %r[/projects/project_name])
      assert_raises(Aliyun::Odps::RequestError) { assert_kind_of Aliyun::Odps::Project, project_service.get('project_name') }
    end
  end

  describe "update" do
    it "should update project" do
      stub_client_request(
        :put,
        "#{endpoint}/projects/Projectname",
        {
          file_path: 'projects/update.xml',
        }
      )

      assert(project_service.update('Projectname', comment: 'ProjectComment'), 'update success')
    end

    it "should raise XmlElementMissingError" do
      assert_raises(Aliyun::Odps::XmlElementMissingError) { assert(project_service.update('project_name'), 'update success') }
    end

    it "should raise RequestError" do
      stub_fail_request(:put, %r[/projects/project_name])
      assert_raises(Aliyun::Odps::RequestError) { assert(project_service.update('project_name', comment: 'Test Comment'), 'update success') }
    end
  end

end
