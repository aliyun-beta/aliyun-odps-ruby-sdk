module Aliyun
  module Odps
    class UploadBlock < Struct::Base
      property :block_id, :String, required: true
      property :create_time, :String
      property :date, :String
    end
  end
end
