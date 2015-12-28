module Aliyun
  module Odps
    module Struct
      class Partition < Base
        def_attr :column, :Hash, required: true
      end
    end
  end
end
