module Aliyun
  module Odps
    module Struct
      class Instance < Base
        attr_accessor :name

        attr_accessor :owner

        attr_accessor :status

        attr_accessor :start_time

        attr_accessor :end_time

        # Get task detail of instance
        #
        # @see http://repo.aliyun.com/api-doc/Instance/get_instance_detail/index.html Get instance detail
        #
        # @params task_name [String] specify task name
        def task_detail(task_name)
          path = "/projects/#{client.current_project}/instances/#{name}"
          query = { instancedetail: true, taskname: task_name }
          client.get(path, query: query).parsed_response
        end

        # Get task progress of instance
        #
        # @see http://repo.aliyun.com/api-doc/Instance/get_instance_progress/index.html Get instance progress
        #
        # @params task_name [String] specify task name
        def task_progress(task_name)
          path = "/projects/#{client.current_project}/instances/#{name}"
          query = { instanceprogress: true, taskname: task_name }
          client.get(path, query: query).parsed_response['Progress']
        end

        # Get task summary of instance
        #
        # @see http://repo.aliyun.com/api-doc/Instance/get_instance_summary/index.html Get instance summary
        #
        # @params task_name [String] specify task name
        def task_summary(task_name)
          path = "/projects/#{client.current_project}/instances/#{name}"
          query = { instancesummary: true, taskname: task_name }
          client.get(path, query: query).parsed_response
        end

        # Get tasks of instance
        #
        # @see http://repo.aliyun.com/api-doc/Instance/get_instance_task/index.html Get instance task
        def tasks
          path = "/projects/#{client.current_project}/instances/#{name}"
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
          path = "/projects/#{client.current_project}/instances/#{name}"
          body = XmlGenerator.generate_put_instance_xml
          !!client.put(path, body: body)
        end
      end
    end
  end
end
