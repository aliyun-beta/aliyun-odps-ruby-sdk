module Aliyun
  module Odps
    class TablePartition < Struct::Base
      property :name, String, required: true
      property :type, String, required: true, within: %w(bigint double boolean datetime string)
      property :comment, String
    end
  end
end
