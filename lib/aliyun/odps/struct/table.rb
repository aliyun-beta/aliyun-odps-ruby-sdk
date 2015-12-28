module Aliyun
  module Odps
    module Struct
      class Table < Base

        def_attr :project, :Project, required: true
        def_attr :client, :Client, required: true

        def_attr :name, :String, required: true
        def_attr :table_id, :String
        def_attr :comment, :String
        def_attr :owner, :String
        def_attr :schema, :Hash
        def_attr :creation_time, :DateTime
        def_attr :last_modified, :DateTime

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

          Aliyun::Odps::List.build(result, %w(Partitions Partition)) do |hash|
            Struct::Partition.new(hash)
          end
        end
      end
    end
  end
end
