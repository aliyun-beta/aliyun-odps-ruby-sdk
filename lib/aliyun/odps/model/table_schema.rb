module Aliyun
  module Odps
    module Model
      class TableSchema < Struct::Base
        def_attr :columns, :Array, init_with: Proc.new {|value|
          value.map {|v| Model::TableColumn.new(v) }
        }

        def_attr :partitions, :Array, init_with: Proc.new {|value|
          value.map {|v| Model::TablePartition.new(v) }
        }
      end
    end
  end
end
