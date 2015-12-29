module Aliyun
  module Odps
    module Model
      class Partition < Struct::Base
        def_attr :column, :Hash, required: true
      end
    end
  end
end
