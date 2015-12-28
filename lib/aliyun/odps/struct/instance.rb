module Aliyun
  module Odps
    module Struct
      class Instance < Base

        def_attr :project, :Project, required: true
        def_attr :client, :Client, required: true

        def_attr :name, :String, required: true
        def_attr :owner, :String
        def_attr :status, :String
        def_attr :start_time, :DateTime
        def_attr :end_time, :DateTime
        def_attr :location, :String

        # Get task detail of instance
        #
        # @see http://repo.aliyun.com/api-doc/Instance/get_instance_detail/index.html Get instance detail
        #
        # @params task_name [String] specify task name
        def task_detail(task_name)
          path = "/projects/#{project.name}/instances/#{name}"
          query = { instancedetail: true, taskname: task_name }
          client.get(path, query: query).parsed_response
        end

        # Get task progress of instance
        #
        # @see http://repo.aliyun.com/api-doc/Instance/get_instance_progress/index.html Get instance progress
        #
        # @params task_name [String] specify task name
        def task_progress(task_name)
          path = "/projects/#{project.name}/instances/#{name}"
          query = { instanceprogress: true, taskname: task_name }
          client.get(path, query: query).parsed_response['Progress']
        end

        # Get task summary of instance
        #
        # @see http://repo.aliyun.com/api-doc/Instance/get_instance_summary/index.html Get instance summary
        #
        # @params task_name [String] specify task name
        def task_summary(task_name)
          path = "/projects/#{project.name}/instances/#{name}"
          query = { instancesummary: true, taskname: task_name }
          client.get(path, query: query).parsed_response
        end

        # Get tasks of instance
        #
        # @see http://repo.aliyun.com/api-doc/Instance/get_instance_task/index.html Get instance task
        def tasks
          path = "/projects/#{project.name}/instances/#{name}"
          query = { taskstatus: true }
          result = client.get(path, query: query).parsed_response

          keys = %w(Instance Tasks Task)
          Utils.wrap(Utils.dig_value(result, *keys)).map do |hash|
            Struct::InstanceTask.new(hash)
          end
        end

        # Terminated instance
        #
        # @see http://repo.aliyun.com/api-doc/Instance/put_instance_terminate/index.html Put instance terminated
        def terminate
          path = "/projects/#{project.name}/instances/#{name}"
          body = XmlGenerator.generate_put_instance_xml
          !!client.put(path, body: body)
        end
      end
    end
  end
end
