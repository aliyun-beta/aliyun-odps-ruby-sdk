
module Aliyun
  module Odps
    class Instance
      extend Aliyun::Odps::Modelable
    end

    class InstanceService < Aliyun::Odps::ServiceObject
      include Aliyun::Odps::Client::Instances
    end
  end
end
