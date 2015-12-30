module Aliyun
  module Odps
    class ServiceObject
      def client
        master.is_a?(Client) ? master : project.client
      end

      def project
        @master.is_a?(Project) ? @master : @master.try(:project)
      end

      attr_reader :master

      def initialize(master, _options = {})
        @master = master
      end

      def self.service_pool
        @service_pool ||= {}
      end

      def self.build(master, options = {})
        service_pool[master] ||= new(master, options)
      end
    end
  end
end
