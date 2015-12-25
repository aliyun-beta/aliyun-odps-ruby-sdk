module Aliyun
  module Odps
    module Struct
      class Project < Base
        attr_accessor :name

        attr_accessor :comment

        attr_accessor :project_group_name

        attr_accessor :state

        attr_accessor :clusters

        attr_accessor :properties

        attr_reader :services

        def tables
          @services ||= {}
          @services[:tables] = Client::TablesService.new(client)
        end

        def functions
          @services ||= {}
          @services[:functions] = Client::FunctionsService.new(client)
        end

        def resources
          @services ||= {}
          @services[:resources] = Client::ResourcesService.new(client)
        end

        def instances
          @services ||= {}
          @services[:instances] = Client::InstancesService.new(client)
        end
      end
    end
  end
end
