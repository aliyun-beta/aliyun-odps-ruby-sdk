require 'aliyun/odps/clients/resources'

module Aliyun
  module Odps
    class Resource
      extend Aliyun::Odps::Modelable
    end
    class ResourceService < Aliyun::Odps::ServiceObject
      include Aliyun::Odps::Clients::Resources
    end
  end
end
