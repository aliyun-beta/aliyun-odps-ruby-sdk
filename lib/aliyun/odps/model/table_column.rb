module Aliyun
  module Odps
    class TableColumn < Struct::Base
      property :name, String, required: true
      property :type, String, required: true, init_with: ->(value) do
        fail NotSupportColumnTypeError, value unless %w(bigint double boolean datetime string).include?(value)
        value
      end
      property :comment, String
      property :label, String
    end
  end
end
