module Aliyun
  module Odps
    # Methods for Tables
    class Tables < ServiceObject
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
          Table.new(hash.merge(project: project))
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
        Table.new(hash)
      end
      alias_method :table, :get

      # Create Table
      #
      # @params name [String] specify table name
      # @params schema [Struct::TableSchema] specify table schema
      # @params options [Hash] options
      # @option options [String] :comment specify table comment
      #
      # @raise InstanceTaskFail
      #
      # @return Table
      def create(name, schema, options = {})
        Utils.stringify_keys!(options)

        table = Table.new(
          name: name,
          schema: schema,
          project: project
        )
        table.comment = options['comment'] if options.key?('comment')

        task = InstanceTask.new(
          name: 'SQLCreateTableTask',
          type: 'SQL',
          query: generate_create_sql(table)
        )

        instance = project.instances.create([task])

        instance.wait_for_success

        table
      end

      # Delete Table
      #
      # @params name [String]
      #
      # @raise RequestError
      #
      # @return true
      def delete(name)
        table = Table.new(
          name: name,
          project: project
        )

        task = InstanceTask.new(
          name: 'SQLDropTableTask',
          type: 'SQL',
          query: generate_drop_sql(table)
        )

        !!project.instances.create([task])
      end

      private

      def generate_create_sql(table)
        sql = ''
        sql += "CREATE TABLE #{project.name}.`#{table.name}`"
        sql += ' (' + table.schema.columns.map do |column|
          "`#{column.name}` #{column.type}" + (column.comment ? " COMMENT '#{column.comment}'" : '')
        end.join(', ') + ')' if table.schema && table.schema.columns
        sql += " COMMENT '#{table.comment}'" if table.comment
        sql += ' PARTITIONED BY (' + table.schema.partitions.map do |column|
          "`#{column.name}` #{column.type}" + (column.comment ? " COMMENT '#{column.comment}'" : '')
        end.join(', ') + ')' if table.schema && table.schema.partitions
        sql += ';'
        sql
      end

      def generate_drop_sql(table)
        "DROP TABLE IF EXISTS #{project.name}.`#{table.name}`;"
      end
    end
  end
end
