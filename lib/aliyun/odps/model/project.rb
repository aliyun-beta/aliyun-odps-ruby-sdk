require 'aliyun/odps/client/projects'
require 'aliyun/odps/model/instance'
require 'aliyun/odps/model/table'
require 'aliyun/odps/model/function'
require 'aliyun/odps/model/resource'

module Aliyun
  module Odps
    class Project
      extend Aliyun::Odps::Modelable
      extend Aliyun::Odps::Client::Projects

      has_many :instances

      has_many :functions

      has_many :tables

      has_many :resources


    end
  end
end
