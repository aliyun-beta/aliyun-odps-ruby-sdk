module Aliyun
  module Odps
    module Struct
      class Function < Base
        attr_accessor :alias

        attr_accessor :owner

        attr_accessor :class_type

        attr_accessor :creation_time

        attr_accessor :resources
      end
    end
  end
end
