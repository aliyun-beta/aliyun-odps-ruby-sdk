require 'aliyun/odps/clients/instances'

module Aliyun
  module Odps
    class Instance
      extend Aliyun::Odps::Modelable
    end

    class InstanceService < Aliyun::Odps::ServiceObject
      include Aliyun::Odps::Clients::Instances
    end
  end
end
