module Aliyun
  module Odps
    class TablePartition < Struct::Base
      def_attr :name, String, required: true
      def_attr :type, String, required: true, within: %w(bigint double boolean datetime string)
      def_attr :comment, String
    end
  end
end
