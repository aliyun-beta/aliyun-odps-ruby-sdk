require 'test_helper'
require 'mocha/test_unit'

module Aliyun
  module Odps
    describe Modelable do

      before do
        class D
          extend Modelable
        end
        class Ds < Aliyun::Odps::ServiceObject
          def list(options={})
            return []
          end

          def create(options={})
            return D.new
          end
        end
        class M
          extend Modelable
          has_many :ds
        end
      end

      it "should support has_many" do

        m = M.new
        assert(m.respond_to?(:ds), 'response to service object')

        assert_equal(Ds.build(m), m.ds)

        assert(m.ds.respond_to?(:list), 'response to list model')
        assert(m.ds.respond_to?(:create), 'response to create model')

        assert_kind_of(D, m.ds.create(name: 'abc'))
        assert_equal([], m.ds.list())

        assert_nil(m.ds.project)

        assert(Aliyun::Odps::Client.new.respond_to?(:projects), 'client has projects')
        assert_kind_of(Aliyun::Odps::Projects, Aliyun::Odps::Client.new.projects)
        assert_nil(Aliyun::Odps::Client.new.projects.project, "Client's projects doesn't have a project")
      end
    end
  end
end
