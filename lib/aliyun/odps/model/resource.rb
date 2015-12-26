module Aliyun
  module Odps
    class Resource
      extend Aliyun::Odps::Modelable
    end
    class ResourceService < Aliyun::Odps::ServiceObject
      include Aliyun::Odps::Client::Resources
    end
  end
end
