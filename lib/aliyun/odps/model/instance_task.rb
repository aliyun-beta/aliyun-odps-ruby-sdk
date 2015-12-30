module Aliyun
  module Odps
    class InstanceTask < Struct::Base
      def_attr :name, :String, required: true
      def_attr :type, :String, required: true, within: %w(SQL SQLPLAN MapReduce DT PLSQL)
      def_attr :comment, :String
      def_attr :property, :Hash, init_with: ->(hash) do
        hash.map { |k, v| { 'Name' => k, 'Value' => v } }
      end
      def_attr :query, :String
      def_attr :start_time, :DateTime
      def_attr :end_time, :DateTime
      def_attr :status, :String
      def_attr :histories, :Array

      def to_hash
        {
          'SQL' => {
            'Name' => name,
            'Comment' => comment || '',
            'Config' => {
              'Property' => property || { 'Name' => '', 'Value' => '' }
            },
            'Query!' => "<![CDATA[#{query}]]>"
          }
        }
      end
    end
  end
end
