module Aliyun
  module Odps
    module Struct
      class Resource < Base
        attr_accessor :name

        attr_accessor :owner

        attr_accessor :last_updator

        attr_accessor :comment

        attr_accessor :resource_type

        attr_accessor :local_path

        attr_accessor :creation_time

        attr_accessor :last_modified_time

        attr_accessor :table_name

        attr_accessor :resource_size

        attr_accessor :resource_content

        attr_accessor :client

        def resource_name=(value)
          self.name = value
        end

        def to_hash
          { 'ResourceName' => name }
        end
      end
    end
  end
end
