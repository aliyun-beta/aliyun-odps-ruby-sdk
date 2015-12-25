module Aliyun
  module Odps
    module Struct
      class Table < Base
        attr_accessor :name

        attr_accessor :table_id

        attr_accessor :comment

        attr_accessor :owner

        attr_accessor :schema

        attr_accessor :creation_time

        attr_accessor :last_modified

        attr_reader :services

        # List partitions of table
        #
        # @see http://repo.aliyun.com/api-doc/Table/get_table_partition/index.html Get table partitions
        #
        # @params name [String] specify the table name
        def partitions
          path = "/projects/#{client.current_project}/tables/#{name}"
          result = client.get(path, query: { partitions: true }).parsed_response

          keys = %w(Partitions Partition)
          Utils.wrap(Utils.dig_value(result, *keys)).map do |_hash|
            Struct::Partition.new(_hash)
          end
        end
      end
    end
  end
end
