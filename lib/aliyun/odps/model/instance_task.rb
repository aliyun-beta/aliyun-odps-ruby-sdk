module Aliyun
  module Odps
    class InstanceTask < Struct::Base
      property :name, String, required: true
      property :type, String, required: true, within: %w(SQL SQLPLAN MapReduce DT PLSQL)
      property :comment, String
      property :property, Hash, init_with: ->(hash) do
        hash.map { |k, v| { 'Name' => k, 'Value' => v } }
      end
      property :query, String
      property :start_time, DateTime
      property :end_time, DateTime
      property :status, String
      property :histories, Array

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
