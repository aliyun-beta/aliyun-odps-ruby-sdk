module Aliyun
  module Odps
    class Table
      extend Aliyun::Odps::Modelable
      extend Aliyun::Odps::Client::Tables
    end
  end
end
