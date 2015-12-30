module Aliyun
  module Odps
    class Instance < Struct::Base
      extend Aliyun::Odps::Modelable

      NAME_PATTERN = /^([a-z]|[A-Z]){1,}([a-z]|[A-Z]|[\d]|_)*/

      def_attr :project, Project, required: true

      def_attr :name, String, required: true
      def_attr :owner, String
      def_attr :comment, String
      def_attr :priority, Integer
      def_attr :tasks, Array
      def_attr :status, String
      def_attr :start_time, DateTime
      def_attr :end_time, DateTime
      def_attr :location, String

      # Get task detail of instance
      #
      # @see http://repo.aliyun.com/api-doc/Instance/get_instance_detail/index.html Get instance detail
      #
      # @params task_name [String] specify task name
      #
      # @return [Hash]
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
      #
      # @return [Hash]
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
      #
      # @return [Hash]
      def task_summary(task_name)
        path = "/projects/#{project.name}/instances/#{name}"
        query = { instancesummary: true, taskname: task_name }
        client.get(path, query: query).parsed_response
      end

      # Get tasks of instance
      #
      # @see http://repo.aliyun.com/api-doc/Instance/get_instance_task/index.html Get instance task
      #
      # @return [List]
      def list_tasks
        path = "/projects/#{project.name}/instances/#{name}"
        query = { taskstatus: true }
        result = client.get(path, query: query).parsed_response

        keys = %w(Instance Tasks Task)
        Utils.wrap(Utils.dig_value(result, *keys)).map do |hash|
          InstanceTask.new(hash)
        end
      end

      # Terminate the instance
      #
      # @see http://repo.aliyun.com/api-doc/Instance/put_instance_terminate/index.html Put instance terminated
      #
      # @return true
      def terminate
        path = "/projects/#{project.name}/instances/#{name}"

        body = Utils.to_xml(
          'Instance' => { 'Status' => 'Terminated' }
        )
        !!client.put(path, body: body)
      end

      # Get status
      #
      # @see http://repo.aliyun.com/api-doc/Instance/get_instance/index.html Get instance
      #
      # @return [String] Instance status: Suspended, Running, Terminated
      def get_status
        path = "/projects/#{project.name}/instances/#{name}"
        result = client.get(path).parsed_response
        Utils.dig_value(result, 'Instance', 'Status')
      end

      # Block process until instance success
      #
      # @raise [InstanceTaskNotSuccessError] if task not success
      def wait_for_success(interval = 0.01)
        wait_for_terminated(interval)

        list_tasks.each do |task|
          if task.status.upcase != 'SUCCESS'
            fail InstanceTaskNotSuccessError, task
          end
        end
      end

      # Block process until instance terminated
      def wait_for_terminated(interval = 0.01)
        sleep interval while get_status != 'Terminated'
      end
    end
  end
end
