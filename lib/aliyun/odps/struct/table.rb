module Aliyun
  module Odps
    module Struct
      class Table < Base
        # required
        attr_accessor :name

        attr_accessor :table_id

        attr_accessor :comment

        attr_accessor :owner

        attr_accessor :schema

        attr_accessor :creation_time

        attr_accessor :last_modified

        # required
        attr_accessor :project

        # required
        attr_accessor :client

        # List partitions of table
        #
        # @see http://repo.aliyun.com/api-doc/Table/get_table_partition/index.html Get table partitions
        #
        # @params options [Hash] options
        # @option options [String] :marker specify marker for paginate
        # @option options [String] :maxitems (1000) specify maxitems in this request
        def partitions(options = {})
          Utils.stringify_keys!(options)
          path = "/projects/#{project.name}/tables/#{name}"
          query = Utils.hash_slice(options, 'marker', 'maxitems').merge(
            partitions: true,
            expectmarker: true
          )
          result = client.get(path, query: query).parsed_response

          keys = %w(Partitions Partition)
          marker = Utils.dig_value(result, 'Partitions', 'Marker')
          max_items = Utils.dig_value(result, 'Partitions', 'MaxItems')
          parts = Utils.wrap(Utils.dig_value(result, *keys)).map do |hash|
            Struct::Partition.new(hash)
          end

          Aliyun::Odps::List.new(marker, max_items, parts)
        end
      end
    end
  end
end
