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
        assign_error_code(response)
        assign_request_id(response)
        @origin_response = response
        super("#{@request_id} - #{@code}: #{@message}")
      end

      def assign_error_code(response)
        result = response.parsed_response
        if result.key?('Error')
          @code = result['Error']['Code']
          @message = result['Error']['Message']
        elsif result.key?('Code')
          @code = result['Code']
          @message = result['Message']
        end
      end

      def assign_request_id(response)
        @request_id = response.headers['x-odps-request-id']
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

    class PriorityInvalidError < Error
      def initialize
        super('Priority must more than or equal to zero.')
      end
    end

    class InstanceTaskNotSuccessError < Error
      def initialize(name, status, task_result)
        super("Task #{name} #{status}: #{task_result}")
      end
    end

    class InstanceNameInvalidError < Error
      def initialize(name)
        super("#{name} should match pattern: #{Instance::NAME_PATTERN}")
      end
    end

    class TunnelEndpointMissingError < Error
      def initialize
        super("Tunnel Endpoint auto detect fail, Use Aliyun::Odps.configure {|config| config.tunnel_endpoint = 'your-project' } to config")
      end
    end

    class ValueNotSupportedError < Error
      def initialize(attr, supported_value)
        super("#{attr} only support: #{Utils.wrap(supported_value).join(', ')} !!")
      end
    end

    class ResourceMissingContentError < Error
      def initialize
        super('A Resource must exist file or table')
      end
    end

    class RecordNotMatchSchemaError < Error
      def initialize(values, schema)
        super("#{values} not match with #{schema}")
      end
    end
  end
end
