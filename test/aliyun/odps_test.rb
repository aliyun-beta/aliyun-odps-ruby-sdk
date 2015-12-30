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
    end

    it 'should get default project' do
      Aliyun::Odps.configure do |config|
        config.project = 'test_project'
      end

      obj = Aliyun::Odps.project
      assert_kind_of(Aliyun::Odps::Project, obj)
      assert_equal('test_project', obj.name)
    end

    it 'should get project' do
      Aliyun::Odps.configure do |config|
        config.project = 'test_project'
      end

      obj = Aliyun::Odps.project('mock_project')
      assert_kind_of(Aliyun::Odps::Project, obj)
      assert_equal('mock_project', obj.name)
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
