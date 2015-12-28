module Aliyun
  module Odps
    module Model
      class TablePartition < Struct::Base
        def_attr :name, :String, required: true
        def_attr :type, :String, required: true, init_with: Proc.new {|value|
          fail NotSupportColumnTypeError, value unless %w{bigint double boolean datetime string}.include?(value)
          value
        }
        def_attr :comment, :String
      end
    end
  end
end
