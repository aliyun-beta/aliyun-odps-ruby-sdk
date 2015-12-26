require 'test_helper'

describe Aliyun::Odps::Struct::UploadSession do
  let(:project_name) { 'mock_project_name' }
  let(:project) { Aliyun::Odps::Struct::Project.new(name: project_name, client: Aliyun::Odps::Client.instance) }
  let(:upload_session) { Aliyun::Odps::Struct::UploadSession.new(table_name: 'table1', upload_id: '1122wwssddd33222', project: project, client: Aliyun::Odps::Client.instance) }

  it "should can upload" do
    stub_fail_request(:put, %r[/projects/#{project_name}/tables/table1])
    assert_raises(Aliyun::Odps::RequestError) { assert upload_session.upload(100, "Hello") }
  end

  it "should view status" do
    stub_fail_request(:get, %r[/projects/#{project_name}/tables/table1])
    assert_raises(Aliyun::Odps::RequestError) { assert_kind_of Hash, upload_session.get_status }
  end

  it "should complete a upload session" do
    stub_fail_request(:post, %r[/projects/#{project_name}/tables/table1])
    assert_raises(Aliyun::Odps::RequestError) { assert_kind_of Hash, upload_session.complete }
  end


end
