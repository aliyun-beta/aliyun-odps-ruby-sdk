module Aliyun
  module Odps
    module Clients
      # Methods for Tables
      module Tables
        # List tables in this project
        #
        # @see http://repo.aliyun.com/api-doc/Table/get_tables/index.html Get tables
        #
        # @params options [Hash] options
        # @option options [String] :name specify the table name
        # @option options [String] :owner specify the table owner
        # @option options [String] :marker
        # @option options [String] :maxitems (1000)
        def list(options = {})
          Utils.stringify_keys!(options)
          path = "/projects/#{project.name}/tables"
          query = Utils.hash_slice(options, 'name', 'owner', 'marker', 'maxitems')
          query.merge!(tables: true, expectmarker: true)
          result = client.get(path, query: query).parsed_response

          Aliyun::Odps::List.build(result, %w(Tables Table)) do |hash|
            Model::Table.new(hash.merge(project: project))
          end
        end

        # Get Table
        #
        # @see http://repo.aliyun.com/api-doc/Table/get_table/index.html Get Table
        #
        # @params name [String] specify the table name
        def get(name)
          path = "/projects/#{project.name}/tables/#{name}"
          resp = client.get(path)

          hash = Utils.dig_value(resp.parsed_response, 'Table')
          hash.merge!(
            'creation_time' => resp.headers['x-odps-creation-time'],
            'last_modified' => resp.headers['Last-Modified'],
            'owner' => resp.headers['x-odps-owner'],
            'project' => project
          )
          Model::Table.new(hash)
        end

        # Create Table
        #
        # @params name [String] specify table name
        # @params schema [Struct::TableSchema] specify table schema
        # @params options [Hash] options
        # @option options [String] :comment specify table comment
        #
        # @raise InstanceTaskFail
        #
        # @return Model::Table
        def create(name, schema, options = {})
          Utils.stringify_keys!(options)

          table = Model::Table.new(
            name: name,
            schema: schema,
            project: project
          )
          table.comment = options['comment'] if options.key?('comment')

          task = Model::InstanceTask.new(
            name: 'SQLCreateTableTask',
            type: 'SQL',
            query: table.generate_create_sql
          )

          instance = project.instances.create([task])

          instance.wait_for_success

          table
        end

        # List partitions of table
        #
        # @see http://repo.aliyun.com/api-doc/Table/get_table_partition/index.html Get table partitions
        #
        # @params name [String] specify the table name
        def partitions(name)
          Model::Table.new(name: name).partitions
        end
      end
    end
  end
end
