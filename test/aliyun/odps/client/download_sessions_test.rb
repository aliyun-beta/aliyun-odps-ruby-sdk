require 'test_helper'

describe Aliyun::Odps::Client::DownloadSessions do
  let(:project_name) { 'mock_project_name' }
  let(:project) { Aliyun::Odps::Struct::Project.new(name: project_name, client: Aliyun::Odps::Client.instance) }

  it "should init new download session" do
    stub_fail_request(:post, %r[/projects/#{project_name}/tables/table_name])
    assert_raises(Aliyun::Odps::RequestError) { assert_kind_of Aliyun::Odps::Struct::DownloadSession, project.table_tunnels.download_sessions.init('table_name') }
  end

end
