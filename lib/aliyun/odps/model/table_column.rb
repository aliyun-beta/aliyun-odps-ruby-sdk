module Aliyun
  module Odps
    class TableColumn < Struct::Base
      def_attr :name, :String, required: true
      def_attr :type, :String, required: true, init_with: Proc.new {|value|
        fail NotSupportColumnTypeError, value unless %w{bigint double boolean datetime string}.include?(value)
        value
      }
      def_attr :comment, :String
      def_attr :label, :String
    end
  end
end
