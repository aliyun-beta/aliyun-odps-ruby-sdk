require 'aliyun/odps/clients/tables'
require 'aliyun/odps/model/table_partition'
require 'aliyun/odps/model/download_session'
require 'aliyun/odps/model/upload_session'

module Aliyun
  module Odps
    module Model
      class Table < Struct::Base
        extend Aliyun::Odps::Modelable

        has_many :download_sessions
        has_many :upload_sessions

        has_many :table_partitions

        def_attr :project, :Project, required: true

        def_attr :name, :String, required: true
        def_attr :table_id, :String
        def_attr :comment, :String
        def_attr :owner, :String
        def_attr :schema, :TableSchema, init_with: Proc.new {|value|
          case value
          when Model::TableSchema
            value
          when Hash
            value = JSON.parse(value['__content__']) if value.key?('__content__')
            Model::TableSchema.new(value)
          end
        }
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
          table_partitions.list(options)
        end

        def generate_create_sql
          sql = ""
          sql += "CREATE TABLE #{project.name}.`#{name}`"
          sql += " (" + schema.columns.map do |column|
            "`#{column.name}` #{column.type}" + (column.comment ? " COMMENT '#{column.comment}'" : "")
          end.join(", ") + ")" if schema && schema.columns
          sql += " COMMENT '#{comment}'" if comment
          sql += " PARTITIONED BY (" + schema.partitions.map do |column|
            "`#{column.name}` #{column.type}" + (column.comment ? " COMMENT '#{column.comment}'" : "")
          end.join(", ") + ")" if schema && schema.partitions
          sql += ";"
        end

        def generate_drop_sql
          "DROP TABLE IF EXISTS #{project.name}.`#{name}`;"
        end
      end

      class TableService < Aliyun::Odps::ServiceObject
        include Aliyun::Odps::Clients::Tables
      end
    end
  end
end

