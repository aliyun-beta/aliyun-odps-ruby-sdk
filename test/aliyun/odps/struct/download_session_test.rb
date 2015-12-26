require 'test_helper'

describe Aliyun::Odps::Struct::DownloadSession do
  let(:project_name) { 'mock_project_name' }
  let(:project) { Aliyun::Odps::Struct::Project.new(name: project_name, client: Aliyun::Odps::Client.instance) }
  let(:download_session) { Aliyun::Odps::Struct::DownloadSession.new(table_name: 'table1', download_id: '1122wwssddd33222', project: project, client: Aliyun::Odps::Client.instance) }

  it "should can download" do
    stub_fail_request(:get, %r[/projects/#{project_name}/tables/table1])
    assert_raises(Aliyun::Odps::RequestError) { assert_kind_of String, download_session.download("(1,100)", "uuid,name") }
  end


end
