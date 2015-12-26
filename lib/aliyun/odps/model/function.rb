module Aliyun
  module Odps
    class Function
      extend Aliyun::Odps::Modelable
    end
    class FunctionService < Aliyun::Odps::ServiceObject
      include Aliyun::Odps::Client::Functions
    end
  end
end
