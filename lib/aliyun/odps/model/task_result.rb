module Aliyun
  module Odps
    class TaskResult < Struct::Base
      property :name, String, required: true
      property :type, String, required: true
      property :result, Hash, required: true
    end
  end
end
