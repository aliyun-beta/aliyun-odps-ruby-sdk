require 'forwardable'

module Aliyun
  module Odps
    # Wrap for simple array and give marker and max_items methods
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

      # Auto detect marker, max_items, values from result,
      # build a object, where you can access marker, max_items, and values
      #
      # @example
      #
      #   Aliyun::Odps::List.build(result, %w(Projects Project)) do |hash|
      #     Project.new(hash.merge(client: client))
      #   end
      #
      # @return [List]
      def self.build(result, keys, &_block)
        top_key = keys.first
        marker = Utils.dig_value(result, top_key, 'Marker')
        max_items = Utils.dig_value(result, top_key, 'MaxItems')
        objects = Utils.wrap(Utils.dig_value(result, *keys)).map do |hash|
          yield hash
        end
        new(marker, max_items, objects)
      end
    end
  end
end
