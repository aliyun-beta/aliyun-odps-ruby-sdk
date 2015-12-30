module Aliyun
  module Odps
    class Error < StandardError; end

    # [Aliyun::Odps::RequestError] when Odps give a Non 2xx response
    class RequestError < Error
      # Error Code defined by Odps
      attr_reader :code

      # Error Message defined by Odps
      attr_reader :message

      # It's the UUID to uniquely identifies this request;
      # When you can't solve the problem, you can request help from the ODPS development engineer with the RequestId.
      attr_reader :request_id

      # The Origin Httparty Response
      attr_reader :origin_response

      def initialize(response)
        if response.parsed_response.key?('Error')
          @code = response.parsed_response['Error']['Code']
          @message = response.parsed_response['Error']['Message']
        elsif response.parsed_response.key?('Code')
          @code = response.parsed_response['Code']
          @message = response.parsed_response['Message']
        else
          @code = response.code
          @message = response.message
        end

        @request_id = response.headers['x-odps-request-id']
        @origin_response = response
        super("#{@request_id} - #{@code}: #{@message}")
      end
    end

    class XmlElementMissingError < Error
      def initialize(element)
        super("Missing #{element} Element in xml")
      end
    end

    class MissingProjectConfigurationError < Error
      def initialize
        super("Must config project first. Use Aliyun::Odps.configure {|config| config.project = 'your-project' }")
      end
    end

    class NotSupportTaskTypeError < Error
      def initialize(type)
        super("Not Support Task Type: #{type}")
      end
    end

    class NotSupportResourceTypeError < Error
      def initialize(type)
        super("Not Support Resource Type: #{type}")
      end
    end

    class NotSupportColumnTypeError < Error
      def initialize(type)
        super("Not Support Column Type: #{type}")
      end
    end

    class PriorityInvalidError < Error
      def initialize
        super('Priority must more than or equal to zero.')
      end
    end

    class InstanceTaskNotSuccessError < Error
      def initialize(task)
        super("Task #{task.name} #{task.status}")
      end
    end

    class InstanceNameInvalidError < Error
      def initialize(_name)
        super("Instance name should match pattern: '([a-z]|[A-Z]){1,}([a-z]|[A-Z]|[\d]|_)*")
      end
    end

    class TunnelEndpointMissingError < Error
      def initialize
        super("Tunnel Endpoint auto detect fail, Use Aliyun::Odps.configure {|config| config.tunnel_endpoint = 'your-project' } to config")
      end
    end
  end
end
