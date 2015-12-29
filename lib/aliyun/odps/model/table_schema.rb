module Aliyun
  module Odps
    class TableSchema < Struct::Base
      def_attr :columns, :Array, init_with: Proc.new {|value|
        value.map {|v| TableColumn.new(v) }
      }

      def_attr :partitions, :Array, init_with: Proc.new {|value|
        value.map {|v| TablePartition.new(v) }
      }
    end
  end
end
