module Aliyun
  module Odps
    class Client
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
          path = "/projects/#{client.current_project}/tables"
          query = Utils.hash_slice(options, 'name', 'owner', 'marker', 'maxitems')
          query.merge!(tables: true, expectmarker: true)
          result = client.get(path, query: query).parsed_response

          keys = %w(Tables Table)
          Utils.wrap(Utils.dig_value(result, *keys)).map do |hash|
            Struct::Table.new(hash)
          end
        end

        # Get Table
        #
        # @see http://repo.aliyun.com/api-doc/Table/get_table/index.html Get Table
        #
        # @params name [String] specify the table name
        def get(name)
          path = "/projects/#{client.current_project}/tables/#{name}"
          resp = client.get(path)

          hash = Utils.dig_value(resp.parsed_response, 'Table')
          hash.merge!(
            'creation_time' => resp.headers['x-odps-creation-time'],
            'last_modified' => resp.headers['Last-Modified'],
            'owner' => resp.headers['x-odps-owner']
          )
          Struct::Table.new(hash)
        end

        # List partitions of table
        #
        # @see http://repo.aliyun.com/api-doc/Table/get_table_partition/index.html Get table partitions
        #
        # @params name [String] specify the table name
        def partitions(name)
          Struct::Table.new(name: name).partitions
        end
      end
    end
  end
end
