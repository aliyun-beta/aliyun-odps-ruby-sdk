module Aliyun
  module Odps
    module Struct
      # @example:
      #
      #   it = Aliyun::Odps::Struct::InstanceTask.new(type: 'SQL', name: 'Test SQL', comment: 'Test', Query: 'Select * from test_table1', property: { 'key1' => 'value1' })
      class InstanceTask < Base
        # Supported value: SQL, SQLPLAN, MapReduce, DT, PLSQL

        def_attr :name, :String, required: true
        def_attr :type, :String, required: true, init_with: Proc.new { |value|
          fail NotSupportTaskTypeError, value unless %w{SQL SQLPLAN MapReduce DT PLSQL}.include?(value)
          value
        }

        def_attr :comment, :String
        def_attr :property, :Hash, init_with: Proc.new { |hash|
          hash.map do |key, value|
            { 'Name' => key, 'Value' => value }
          end
        }
        def_attr :query, :String
        def_attr :start_time, :DateTime
        def_attr :end_time, :DateTime
        def_attr :status, :String
        def_attr :histories, :Array

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

      end
    end
  end
end
