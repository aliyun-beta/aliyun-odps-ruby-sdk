module Aliyun
  module Odps
    class TaskResult < Struct::Base
      def_attr :name, String, required: true
      def_attr :type, String, required: true
      def_attr :result, Hash, required: true
    end
  end
end
