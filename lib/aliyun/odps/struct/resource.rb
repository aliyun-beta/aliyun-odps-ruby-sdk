module Aliyun
  module Odps
    module Struct
      class Resource < Base

        def_attr :name, :String, required: true
        def_attr :owner, :String
        def_attr :last_updator, :String
        def_attr :comment, :String
        def_attr :resource_type, :String
        def_attr :local_path, :String
        def_attr :creation_time, :DateTime
        def_attr :last_modified_time, :DateTime
        def_attr :table_name, :String
        def_attr :resource_size, :Integer
        def_attr :content, :String
        def_attr :location, :String

        alias_method :resource_name=, :name=

        def to_hash
          { 'ResourceName' => name }
        end
      end
    end
  end
end
