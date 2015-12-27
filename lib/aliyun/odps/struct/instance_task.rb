module Aliyun
  module Odps
    module Struct
      # @example:
      #
      #   it = Aliyun::Odps::Struct::InstanceTask.new(type: 'SQL', name: 'Test SQL', comment: 'Test', Query: 'Select * from test_table1', property: { 'key1' => 'value1' })
      class InstanceTask < Base
        # Supported value: SQL, SQLPLAN, MapReduce, DT, PLSQL
        attr_accessor :type

        attr_accessor :name

        attr_accessor :comment

        attr_accessor :property

        attr_accessor :query

        attr_accessor :start_time

        attr_accessor :end_time

        attr_accessor :status

        attr_accessor :histories

        def to_hash
          {
            'SQL' => {
              'Name' => name,
              'Comment' => comment,
              'Config' => {
                'Property' => property || { 'Name' => '', 'Value' => '' }
              },
              'Query!' => "<![CDATA[#{query}]]>"
            }
          }
        end

        def property=(property_hash)
          @property = property_hash.map do |key, value|
            { 'Name' => key, 'Value' => value }
          end
        end
      end
    end
  end
end
