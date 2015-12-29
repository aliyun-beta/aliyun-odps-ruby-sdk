module Aliyun
  module Odps
    module Clients
      # Methods for Instances
      module Instances
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
        def list(options = {})
          Utils.stringify_keys!(options)
          path = "/projects/#{project.name}/instances"
          query = Utils.hash_slice(options, 'datarange', 'status', 'jobname', 'onlyowner', 'marker', 'maxitems')
          result = client.get(path, query: query).parsed_response

          Aliyun::Odps::List.build(result, %w(Instances Instance)) do |hash|
            Model::Instance.new(hash.merge(project: project))
          end
        end

        # Create a instance job
        #
        # @see http://repo.aliyun.com/api-doc/Instance/post_instance/index.html Post Instance
        #
        # @params tasks [Array<Model::InstanceTask]> a list for instance_task
        # @params options [String] options
        # @option options [String] :name Specify the instance name
        # @option options [String] :comment Specify comment of the instance
        # @option options [Integer] :priority Specify priority of the instance
        def create(tasks = [], options = {})
          Utils.stringify_keys!(options)

          name = options.key?('name') ? options['name'] : Utils.generate_uuid('instance')

          instance = Model::Instance.new(
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

          resp = client.post(path, body: instance.build_create_body)

          instance.tap do |obj|
            obj.location = resp.headers['Location']
            obj.name = obj.location.split("/").last if obj.location
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
          instance = Model::Instance.new(
            name: name,
            project: project
          )

          instance.get_status
        end
      end
    end
  end
end
