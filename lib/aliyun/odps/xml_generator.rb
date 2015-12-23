module Aliyun
  module Odps
    class XmlGenerator
      def self.generate_update_project_xml(name, options)
        Utils.to_xml(
          'Project' => {
            'Name' => name,
            'Comment' => options['comment']
          })
      end

      def self.generate_create_instance_xml(name, comment, priority, tasks)
        Utils.to_xml(
          'Instance' => {
            'Job' => {
              'Name' => name,
              'Comment' => comment,
              'Priority' => priority,
              'Tasks' => tasks.map(&:to_hash)
            }
          }
        )
      end

    end
  end
end
