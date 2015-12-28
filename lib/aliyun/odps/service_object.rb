module Aliyun
  module Odps
    class ServiceObject
      def client
        Aliyun::Odps::Client.instance
      end

      def project
        # so far doesn't support 2nd level object
        @master.kind_of?(Model::Project) ?  @master : @master.try(:project)
      end

      attr_reader :master

      def initialize(master, options = {})
        @master = master
      end

      def self.service_pool
        @service_pool ||= {}
      end

      def self.build(master, options = {})
        service_pool[master] ||= self.new(master, options)
      end
    end
  end
end
