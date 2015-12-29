require 'aliyun/odps/clients/table_partitions'

module Aliyun
  module Odps
    module Model
      class TablePartition < Struct::Base
        extend Aliyun::Odps::Modelable

        def_attr :name, :String, required: true
        def_attr :type, :String, required: true, init_with: Proc.new {|value|
          fail NotSupportColumnTypeError, value unless %w{bigint double boolean datetime string}.include?(value)
          value
        }
        def_attr :comment, :String
      end

      class TablePartitionService < Aliyun::Odps::ServiceObject
        include Aliyun::Odps::Clients::TablePartitions
      end
    end
  end
end
