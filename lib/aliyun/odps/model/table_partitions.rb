module Aliyun
  module Odps
    # Methods for TablePartitions
    class TablePartitions < ServiceObject
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
          Hash[Utils.wrap(hash['Column']).map(&:values)]
        end
      end

      # Create Partition
      #
      # @params partitions_spec [Hash<name, value>] specify the partition spec
      def create(partition_spec)
        sql = generate_create_sql(partition_spec)

        task = InstanceTask.new(
          name: 'SQLCreatePartitionTask',
          type: 'SQL',
          query: sql
        )

        instance = project.instances.create([task])

        instance.wait_for_success

        partition_spec
      end

      # Delete Partition
      #
      # @params partitions_spec [Hash<name, value>] specify the partition spec
      def delete(partition_spec)
        sql = generate_drop_sql(partition_spec)

        task = InstanceTask.new(
          name: 'SQLDropPartitionTask',
          type: 'SQL',
          query: sql
        )

        !!project.instances.create([task])
      end

      private

      def generate_create_sql(partition_spec)
        spec = partition_spec.map { |k, v| "#{k} = '#{v}'" }.join(',')
        "ALTER TABLE #{project.name}.`#{master.name}` ADD PARTITION (#{spec});"
      end

      def generate_drop_sql(partition_spec)
        spec = partition_spec.map { |k, v| "#{k} = '#{v}'" }.join(',')
        "ALTER TABLE #{project.name}.`#{master.name}`DROP IF EXISTS PARTITION (#{spec});"
      end
    end
  end
end
