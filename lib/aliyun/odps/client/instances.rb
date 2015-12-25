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
        # @option options [String] :datarange 指定查询instance 开始运行的时间范围。格式为：daterange=[n1]:[n2] ，其中n1是指时间范围的开始，n2为结束。n1和n2是将时间日期转换成整型后的数值。省略n1，查询条件为截止到n2,格式为:n2；省略n2，查询条件为从n1开始截到现在，格式为 n1:；同时省略n1和n2等同于忽略daterange查询条件
        # @option options [String] :status supported value: Running, Suspended, Terminated
        # @option jobname [String] :jobname specify the job name
        # @option onlyowner [String] :onlyowner (yes) supported value: yes, no
        # @option options [String] :marker
        # @option options [String] :maxitems (1000)
        def list(options = {})
          Utils.stringify_keys!(options)
          path = "/projects/#{client.current_project}/instances"
          query = Utils.hash_slice(options, 'datarange', 'status', 'jobname', 'onlyowner', 'marker', 'maxitems')
          result = client.get(path, query: query).parsed_response

          keys = %w(Instances Instance)
          Utils.wrap(Utils.dig_value(result, *keys)).map do |_hash|
            Struct::Instance.new(_hash.merge(client: client.soft_clone))
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
          path = "/projects/#{client.current_project}/instances"
          body = XmlGenerator.generate_create_instance_xml(name, comment, priority, tasks)
          client.post(path, body: body).headers['Location']
        end

        # Get status of instance
        #
        # @see http://repo.aliyun.com/api-doc/Instance/get_instance/index.html Get instance
        #
        # @params name [String] specify the instance name
        #
        # @return Instance status: Suspended, Running, Terminated
        def status(name)
          path = "/projects/#{client.current_project}/instances/#{name}"
          result = client.get(path).parsed_response
          Utils.dig_value(result, 'Instance', 'Status')
        end
      end
    end
  end
end
