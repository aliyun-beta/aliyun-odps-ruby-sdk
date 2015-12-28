module Aliyun
  module Odps
    module Struct
      class Function < Base
        def_attr :name, :String, required: true
        def_attr :owner, :String
        def_attr :class_type, :String
        def_attr :creation_time, :DateTime
        def_attr :resources, :Array
        def_attr :location, :String

        alias_method :alias=, :name=

        def build_create_body
          fail XmlElementMissingError, 'ClassType' if class_type.nil?
          fail XmlElementMissingError, 'Resources' if resources.empty?

          Utils.to_xml(
            'Function' => {
              'Alias' => name,
              'ClassType' => class_type,
              'Resources' => resources.map(&:to_hash)
            }
          )
        end
      end
    end
  end
end
