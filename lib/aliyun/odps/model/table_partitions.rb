module Aliyun
  module Odps
    class TablePartitions < ServiceObject
      # List partitions for table
      #
      # @see http://repo.aliyun.com/api-doc/Table/get_table_partition/index.html Get table partitions
      #
      # @param options [Hash] options
      # @option options [String] :marker specify marker for paginate
      # @option options [String] :maxitems (1000) specify maxitems in this request
      #
      # @return [List]
      def list(options = {})
        Utils.stringify_keys!(options)
        path = "/projects/#{project.name}/tables/#{master.name}"
        query = {
          partitions: true,
          expectmarker: true
        }.merge(Utils.hash_slice(options, 'marker', 'maxitems'))

        result = client.get(path, query: query).parsed_response
        Aliyun::Odps::List.build(result, %w(Partitions Partition)) do |hash|
          build_table_partition(hash)
        end
      end

      # Create Partition
      #
      # @param partition [Hash<name, value>] specify the partition you want to create
      #
      # @raise InstanceTaskNotSuccessError if instance task failed
      #
      # @return [Hash] the partition you create
      def create(partition)
        sql = generate_create_sql(partition)

        task = InstanceTask.new(
          name: 'SQLCreatePartitionTask',
          type: 'SQL',
          query: sql
        )

        instance = project.instances.create([task])

        instance.wait_for_success

        partition
      end

      # Delete Partition
      #
      # @params partitions [Hash<name, value>] specify the partition you want to delete
      #
      # @raise InstanceTaskNotSuccessError if instance task failed
      #
      # @return [true]
      def delete(partition)
        sql = generate_drop_sql(partition)

        task = InstanceTask.new(
          name: 'SQLDropPartitionTask',
          type: 'SQL',
          query: sql
        )

        instance = project.instances.create([task])

        instance.wait_for_success

        true
      end

      private

      def generate_create_sql(partition)
        spec = partition.map { |k, v| "#{k} = '#{v}'" }.join(',')
        "ALTER TABLE #{project.name}.`#{master.name}` ADD PARTITION (#{spec});"
      end

      def generate_drop_sql(partition)
        spec = partition.map { |k, v| "#{k} = '#{v}'" }.join(',')
        "ALTER TABLE #{project.name}.`#{master.name}`DROP IF EXISTS PARTITION (#{spec});"
      end

      def build_table_partition(hash)
        Hash[Utils.wrap(hash['Column']).map(&:values)]
      end
    end
  end
end
