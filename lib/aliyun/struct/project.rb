module Aliyun
  module Odps
    class Project
      def tables
        @services[:tables] ||= Client::TablesService.new(self)
      end

      def resources
        @services[:resources] ||= Client::ResourcesService.new(self)
      end

      def instances
        @services[:instances] ||= \
          Client::InstancesService.new(self)
      end

      def functions
        @services[:functions] ||= \
          Client::FunctionsService.new(self)
      end
    end
  end
end
