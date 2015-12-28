require 'aliyun/odps/clients/projects'
require 'aliyun/odps/model/instance'
require 'aliyun/odps/model/table'
require 'aliyun/odps/model/function'
require 'aliyun/odps/model/resource'
require 'aliyun/odps/model/table_tunnel'

module Aliyun
  module Odps
    class Project
      extend Aliyun::Odps::Modelable

      has_many :instances

      has_many :functions

      has_many :tables

      has_many :resources

      has_many :table_tunnels


    end

    class ProjectService < Aliyun::Odps::ServiceObject
      include Aliyun::Odps::Clients::Projects
    end
  end
end
