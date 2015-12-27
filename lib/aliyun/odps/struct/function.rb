module Aliyun
  module Odps
    module Struct
      class Function < Base
        attr_accessor :name

        attr_accessor :owner

        attr_accessor :class_type

        attr_accessor :creation_time

        attr_accessor :resources

        attr_accessor :location

        def alias=(value)
          self.name = value
        end
      end
    end
  end
end
