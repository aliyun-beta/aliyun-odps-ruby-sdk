module Aliyun
  module Odps
    module Struct
      class Resource < Base
        attr_accessor :name

        attr_accessor :owner

        attr_accessor :last_updator

        attr_accessor :comment

        attr_accessor :resource_type

        attr_accessor :local_path

        attr_accessor :creation_time

        attr_accessor :last_modified_time

        attr_accessor :table_name

        attr_accessor :resource_size

        attr_accessor :content

        attr_accessor :location

        def resource_name=(value)
          self.name = value
        end

        %w{last_modified_time creation_time}.each do |attr|
          define_method "#{attr}=" do |value|
            begin
              time = DateTime.parse(value)
              instance_variable_set("@#{attr}", time)
            rescue => e
              puts "Invalid Time"
            end
          end
        end

        def resource_size=(value)
          @resource_size = value.to_i
        end

        def to_hash
          { 'ResourceName' => name }
        end
      end
    end
  end
end
