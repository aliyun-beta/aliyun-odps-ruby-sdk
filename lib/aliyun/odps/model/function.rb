require 'aliyun/odps/clients/projects'

module Aliyun
  module Odps
    class Function
      extend Aliyun::Odps::Modelable
    end
    class FunctionService < Aliyun::Odps::ServiceObject
      include Aliyun::Odps::Clients::Functions
    end
  end
end
