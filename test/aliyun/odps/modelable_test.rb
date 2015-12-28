require 'test_helper'
require 'mocha/test_unit'

module Aliyun
  module Odps
    describe Modelable do

      before do
        class Model::D
          extend Modelable
        end
        class Model::DService < Aliyun::Odps::ServiceObject
          def list(options={})
            return []
          end

          def create(options={})
            return Model::D.new
          end
        end
        class Model::M
          extend Modelable
          has_many :ds
        end
      end

      it "should support has_many" do

        m = Model::M.new
        assert(m.respond_to?(:ds), 'response to service object')

        assert_equal(Model::DService.build(m), m.ds)

        assert(m.ds.respond_to?(:list), 'response to list model')
        assert(m.ds.respond_to?(:create), 'response to create model')

        assert_kind_of(Model::D, m.ds.create(name: 'abc'))
        assert_equal([], m.ds.list())

        assert_nil(m.ds.project)

        assert(Aliyun::Odps::Client.instance.respond_to?(:projects), 'client has projects')
        assert_kind_of(Aliyun::Odps::Model::ProjectService, Aliyun::Odps::Client.instance.projects)
        assert_nil(Aliyun::Odps::Client.instance.projects.project, "Client's projects doesn't have a project")
      end
    end
  end
end
