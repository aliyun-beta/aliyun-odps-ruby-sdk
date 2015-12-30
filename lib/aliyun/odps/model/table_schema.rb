module Aliyun
  module Odps
    class TableSchema < Struct::Base
      def_attr :columns, :Array, init_with: ->(value) do
        value.map { |v| TableColumn.new(v) }
      end

      def_attr :partitions, :Array, init_with: ->(value) do
        value.map { |v| TablePartition.new(v) }
      end
    end
  end
end
