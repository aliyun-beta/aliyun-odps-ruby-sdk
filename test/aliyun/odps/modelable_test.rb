require 'test_helper'
require 'mocha/test_unit'

module Aliyun
  module Odps
    describe Modelable do

      before do
        class D
          extend Modelable
          class << self
            def list(options={})
              return []
            end

            def create(options={})
              return self.new
            end
          end
        end
        class M
          extend Modelable
          has_many :ds, actions: [:create]
        end
      end

      it "should support has_many" do
        begin
          m = M.new
          assert(m.respond_to?(:ds), 'response to collection')

          assert_equal([], m.ds)

          assert(m.respond_to?(:create_d), 'response to create model')

          assert_kind_of(D, m.create_d(name: 'abc'))

          # must provide options when you call method of model class
          assert_raises {
            m.create_d
          }
        rescue Exception => e
          flunk(e)
        end
      end
    end
  end
end
