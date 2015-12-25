module Aliyun
  module Odps
    class Error < StandardError; end

    # [Aliyun::Oss::RequestError] when OSS give a Non 2xx response
    class RequestError < Error
      # Error Code defined by OSS
      attr_reader :code

      # Error Message defined by OSS
      attr_reader :message

      # It's the UUID to uniquely identifies this request;
      # When you can't solve the problem, you can request help from the OSS development engineer with the RequestId.
      attr_reader :request_id

      # The Origin Httparty Response
      attr_reader :origin_response

      def initialize(response)
        error =
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
  end
end
