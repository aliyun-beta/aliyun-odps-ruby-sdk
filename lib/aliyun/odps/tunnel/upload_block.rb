module Aliyun
  module Odps
    class UploadBlock < Struct::Base

      def_attr :block_id, :String, required: true
      def_attr :create_time, :String
      def_attr :date, :String
    end
  end
end
