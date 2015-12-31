require 'aliyun/odps/model/table_partitions'
require 'aliyun/odps/model/table_schema'

module Aliyun
  module Odps
    class Table < Struct::Base
      extend Aliyun::Odps::Modelable

      # @!method table_partitions
      # @return [TablePartitions]
      has_many :table_partitions

      def_attr :project, Project, required: true

      def_attr :name, String, required: true
      def_attr :table_id, String
      def_attr :comment, String
      def_attr :owner, String
      def_attr :schema, TableSchema, init_with: ->(value) do
        case value
        when TableSchema
          value
        when Hash
          value = JSON.parse(value['__content__']) if value.key?('__content__')
          TableSchema.new(value)
        end
      end
      def_attr :creation_time, DateTime
      def_attr :last_modified, DateTime

      # (see TablePartitions#list)
      def partitions(options = {})
        table_partitions.list(options)
      end
    end
  end
end
