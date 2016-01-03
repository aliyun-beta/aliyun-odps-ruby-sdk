require 'aliyun/odps/model/table_partitions'
require 'aliyun/odps/model/table_schema'

module Aliyun
  module Odps
    class Table < Struct::Base
      extend Aliyun::Odps::Modelable

      # @!method table_partitions
      # @return [TablePartitions]
      has_many :table_partitions

      property :project, Project, required: true

      property :name, String, required: true
      property :table_id, String
      property :comment, String
      property :owner, String
      property :schema, TableSchema, init_with: ->(value) do
        case value
        when TableSchema
          value
        when Hash
          value = JSON.parse(value['__content__']) if value.key?('__content__')
          TableSchema.new(value)
        end
      end
      property :creation_time, DateTime
      property :last_modified, DateTime

      # (see TablePartitions#list)
      def partitions(options = {})
        table_partitions.list(options)
      end
    end
  end
end
