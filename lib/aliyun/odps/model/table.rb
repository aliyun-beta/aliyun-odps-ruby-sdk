require 'aliyun/odps/clients/tables'

module Aliyun
  module Odps
    class Table
      extend Aliyun::Odps::Modelable
    end
    class TableService < Aliyun::Odps::ServiceObject
      include Aliyun::Odps::Clients::Tables
    end
  end
end
