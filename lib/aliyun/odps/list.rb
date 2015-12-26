require 'forwardable'

module Aliyun
  module Odps
    class List
      include Enumerable
      extend Forwardable
      attr_reader :marker, :max_items
      def_delegators :@objects, :[], :each, :size, :inspect

      def initialize(marker, max_items, objects)
        @marker = marker
        @max_items = max_items.to_i
        @objects = objects
      end
    end
  end
end
