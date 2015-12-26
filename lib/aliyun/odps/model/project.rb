require 'aliyun/odps/client/projects'
require 'aliyun/odps/model/instance'
require 'aliyun/odps/model/table'
require 'aliyun/odps/model/function'
require 'aliyun/odps/model/resource'

module Aliyun
  module Odps
    class Project
      extend Aliyun::Odps::Modelable

      has_many :instances

      has_many :functions

      has_many :tables

      has_many :resources


    end

    class ProjectService < Aliyun::Odps::ServiceObject
      include Aliyun::Odps::Client::Projects
    end
  end
end
