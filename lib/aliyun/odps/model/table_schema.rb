module Aliyun
  module Odps
    class TableSchema < Struct::Base
      property :columns, Array, init_with: ->(value) do
        value.map { |v| TableColumn.new(v) }
      end

      property :partitions, Array, init_with: ->(value) do
        value.map { |v| TablePartition.new(v) }
      end
    end
  end
end
