module Aliyun
  module Odps
    class ServiceObject
      def client
        Aliyun::Odps::Client.instance
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
