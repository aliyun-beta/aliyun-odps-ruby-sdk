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
            Struct::Instance.new(hash.merge(project: project, client: project.client))
          end
        end

        # Create a instance job
        #
        # @see http://repo.aliyun.com/api-doc/Instance/post_instance/index.html Post Instance
        #
        # @params name [String] Specify the instance name
        # @params comment [String] Specify comment of the instance
        # @params priority [Integer] Specify priority of the instance
        # @params tasks [Array<Struct::InstanceTask]> a list for instance_task
        def create(name, comment, priority, tasks = [])
          path = "/projects/#{project.name}/instances"

          instance = Struct::Instance.new(
            name: name,
            comment: comment,
            priority: priority,
            tasks: tasks,
            client: client,
            project: project
          )

          resp = client.post(path, body: instance.build_create_body)

          instance.tap do |obj|
            obj.location = resp.headers['Location']
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
          path = "/projects/#{project.name}/instances/#{name}"
          result = client.get(path).parsed_response
          Utils.dig_value(result, 'Instance', 'Status')
        end
      end
    end
  end
end
