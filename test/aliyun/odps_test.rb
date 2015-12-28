require 'test_helper'

describe Aliyun::Odps do
  it 'that it has a version number' do
    refute_nil ::Aliyun::Odps::VERSION
  end

  describe "project" do
    it "should get default project" do
      Aliyun::Odps.configure do |config|
        config.project = 'test_project'
      end

      assert_kind_of(Aliyun::Odps::Model::Project, Aliyun::Odps.project)
    end

    it "should raise MissingProjectConfiguration" do
      Aliyun::Odps.configure do |config|
        config.project = nil
      end

      assert_raises(Aliyun::Odps::MissingProjectConfigurationError) do
        assert_kind_of(Aliyun::Odps::Model::Project, Aliyun::Odps.project)
      end
    end
  end
end
