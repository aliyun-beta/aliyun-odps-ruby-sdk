require 'test_helper'

describe Aliyun::Odps do
  it 'that it has a version number' do
    refute_nil ::Aliyun::Odps::VERSION
  end

  describe 'project' do
    before do
      @default_project = Aliyun::Odps.config.project
    end

    after do
      Aliyun::Odps.configure do |config|
        config.project = @default_project
      end
      Aliyun::Odps::Client.any_instance.unstub(:projects)
    end

    it 'should get default project' do
      Aliyun::Odps.configure do |config|
        config.project = 'test_project'
      end

      projects_service = stubs(get: true)
      Aliyun::Odps::Client.any_instance.stubs(:projects).returns(projects_service)

      projects_service.expects(:get).with('test_project')
      obj = Aliyun::Odps.project
    end

    it 'should get project' do
      Aliyun::Odps.configure do |config|
        config.project = 'test_project'
      end

      projects_service = stubs(get: true)
      Aliyun::Odps::Client.any_instance.stubs(:projects).returns(projects_service)

      projects_service.expects(:get).with('mock_project')
      obj = Aliyun::Odps.project('mock_project')
    end

    it 'should raise MissingProjectConfiguration' do
      Aliyun::Odps.configure do |config|
        config.project = nil
      end

      assert_raises(Aliyun::Odps::MissingProjectConfigurationError) do
        assert_kind_of(Aliyun::Odps::Project, Aliyun::Odps.project)
      end
    end
  end
end
