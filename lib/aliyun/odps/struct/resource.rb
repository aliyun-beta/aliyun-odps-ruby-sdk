module Aliyun
  module Odps
    module Struct
      class Resource < Base

        attr_accessor :resource_name

        attr_accessor :client

        def to_hash
          { 'ResourceName' => resource_name }
        end

      end
    end
  end
end
