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
        # @params name [String] specify the table name
        def partitions
          path = "/projects/#{project.name}/tables/#{name}"
          result = client.get(path, query: { partitions: true }).parsed_response

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
