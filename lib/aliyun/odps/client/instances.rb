module Aliyun
  module Odps
    class Client
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

          keys = %w(Instances Instance)
          marker = Utils.dig_value(result, 'Instances', 'Marker')
          max_items = Utils.dig_value(result, 'Instances', 'MaxItems')
          instances = Utils.wrap(Utils.dig_value(result, *keys)).map do |hash|
            Struct::Instance.new(hash.merge(project: project))
          end
          Aliyun::Odps::List.new(marker, max_items, instances)
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
          body = XmlGenerator.generate_create_instance_xml(name, comment, priority, tasks)

          location = client.post(path, body: body).headers['Location']
          Aliyun::Odps::Struct::Instance.new(name: name, location: location, project: project, client: client)
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
