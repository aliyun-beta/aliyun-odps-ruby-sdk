require 'aliyun/odps/clients/partitions'

module Aliyun
  module Odps
    module Model
      class Partition < Struct::Base
        extend Aliyun::Odps::Modelable

        def_attr :column, :Hash, required: true
      end

      class PartitionService < Aliyun::Odps::ServiceObject
        include Aliyun::Odps::Clients::Partitions
      end
    end
  end
end
