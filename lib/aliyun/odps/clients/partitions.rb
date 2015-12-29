module Aliyun
  module Odps
    module Clients
      # Methods for Partitions
      module Partitions

        # List partitions of table
        #
        # @see http://repo.aliyun.com/api-doc/Table/get_table_partition/index.html Get table partitions
        #
        # @params options [Hash] options
        # @option options [String] :marker specify marker for paginate
        # @option options [String] :maxitems (1000) specify maxitems in this request
        def list(options = {})
          Utils.stringify_keys!(options)
          path = "/projects/#{project.name}/tables/#{master.name}"
          query = Utils.hash_slice(options, 'marker', 'maxitems').merge(
            partitions: true,
            expectmarker: true
          )
          result = client.get(path, query: query).parsed_response

          Aliyun::Odps::List.build(result, %w(Partitions Partition)) do |hash|
            Model::Partition.new(hash)
          end
        end
      end
    end
  end
end
