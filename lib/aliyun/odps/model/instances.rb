module Aliyun
  module Odps
    class Instances < ServiceObject
      # List instances of project
      #
      # @see http://repo.aliyun.com/api-doc/Instance/get_instances/index.html Get instances
      #
      # @params options [Hash] options
      #
      # @option options [String] :datarange specify the starttime range time range
      # @option options [String] :status supported value: Running, Suspended, Terminated
      # @option jobname [String] :jobname specify the job name
      # @option onlyowner [String] :onlyowner (yes) supported value: yes, no
      # @option options [String] :marker
      # @option options [String] :maxitems (1000)
      #
      # @return [List]
      def list(options = {})
        Utils.stringify_keys!(options)
        path = "/projects/#{project.name}/instances"
        query = Utils.hash_slice(options, 'datarange', 'status', 'jobname', 'onlyowner', 'marker', 'maxitems')
        result = client.get(path, query: query).parsed_response

        Aliyun::Odps::List.build(result, %w(Instances Instance)) do |hash|
          Instance.new(hash.merge(project: project))
        end
      end

      # Create a instance job
      #
      # @see http://repo.aliyun.com/api-doc/Instance/post_instance/index.html Post Instance
      #
      # @params tasks [Array<InstanceTask>] a list of instance_task
      # @params options [String] options
      # @option options [String] :name Specify the instance name
      # @option options [String] :comment Specify comment of the instance
      # @option options [Integer] :priority Specify priority of the instance
      #
      # @raise InstanceNameInvalidError if instance name not valid
      #
      # @return [Instance]
      def create(tasks, options = {})
        Utils.stringify_keys!(options)

        name = options.key?('name') ? options['name'] : Utils.generate_uuid('instance')

        unless name.match(Instance::NAME_PATTERN)
          fail InstanceNameInvalidError, name
        end

        instance = Instance.new(
          name: name,
          tasks: tasks,
          project: project,
          priority: 9,
          client: client
        )

        if options.key?('priority')
          fail PriorityInvalidError if options['priority'] < 0
          instance.priority = options['priority']
        end

        instance.comment = options['comment'] if options['comment']

        path = "/projects/#{project.name}/instances"

        resp = client.post(path, body: build_create_body(instance))

        instance.tap do |obj|
          obj.location = resp.headers['Location']
          obj.name = obj.location.split('/').last if obj.location
        end
      end

      # Get status of instance
      #
      # @see http://repo.aliyun.com/api-doc/Instance/get_instance/index.html Get instance
      #
      # @params name [String] specify the instance name
      #
      # @return Instance status: Suspended, Running, Terminated
      def status(name)
        instance = Instance.new(
          name: name,
          project: project
        )

        instance.get_status
      end

      private

      def build_create_body(instance)
        fail XmlElementMissingError, 'Priority' if instance.priority.nil?
        fail XmlElementMissingError, 'Tasks' if instance.tasks.empty?

        Utils.to_xml({
          'Instance' => {
            'Job' => {
              'Name' => instance.name,
              'Comment' => instance.comment || '',
              'Priority' => instance.priority,
              'Tasks' => instance.tasks.map(&:to_hash),
            }
          }
        },
        unwrap: true
        )
      end
    end
  end
end
