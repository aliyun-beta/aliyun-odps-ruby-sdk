module Aliyun
  module Odps
    module Struct
      class Function < Base
        def_attr :name, :String, required: true
        def_attr :owner, :String
        def_attr :class_type, :String
        def_attr :creation_time, :DateTime
        def_attr :resources, :Array
        def_attr :location, :String

        alias_method :alias=, :name=
      end
    end
  end
end
