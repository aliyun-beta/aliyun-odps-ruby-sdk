module Aliyun
  module Odps
    class Function < Struct::Base
      extend Aliyun::Odps::Modelable

      property :name, String, required: true
      property :owner, String
      property :class_type, String
      property :creation_time, DateTime
      property :resources, Array
      property :location, String

      alias_method :alias=, :name=
    end
  end
end
