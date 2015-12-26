module Aliyun
  module Odps
    class Table
      extend Aliyun::Odps::Modelable
    end
    class TableService < Aliyun::Odps::ServiceObject
      include Aliyun::Odps::Client::Tables
    end
  end
end
