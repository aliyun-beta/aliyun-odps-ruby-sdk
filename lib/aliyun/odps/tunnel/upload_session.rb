module Aliyun
  module Odps
    class UploadSession < Struct::Base
      extend Aliyun::Odps::Modelable

      def_attr :project, :Project, required: true

      def_attr :upload_id, :String, required: true
      def_attr :table_name, :String, required: true
      def_attr :partition_spec, :String
      def_attr :status, :String
      def_attr :owner, :String
      def_attr :initiated, :DateTime
      def_attr :schema, :Hash

      # Upload data in block
      #
      # @see http://repo.aliyun.com/api-doc/Tunnel/put_create_upload_id/index.html Put Upload Block ID
      #
      # @params blockid [String] specify blockid for this upload, range in 0~limitsize
      # @params file_or_bin [File|Bin Data] specify the data, a local file path or raw data
      # @params options [Hash] options
      # @option options [String] :tunnel_version specify the Tunnel version
      # @option options [String] :encoding specify the data compression format, supported value: Raw, Zlib(deflate), defalte/x-snappy-framed
      def upload(blockid, file_or_bin, options = {})
        Utils.stringify_keys!(options)
        path = "/projects/#{project.name}/tables/#{table_name}"

        query = { blockid: blockid, uploadid: upload_id }
        query.merge!(partition: partition_spec) if partition_spec

        headers = {}
        headers.merge!( "x-odps-tunnel-version" => options["tunnel_version"] ) if options.key?('tunnel_version')
        headers.merge!( "Content-Encoding" => options["encoding"] ) if options.key?('encoding')

        !!client.put(path, query: query, headers: headers, body: Utils.to_data(file_or_bin))
      end

      # View status of upload session
      #
      # @see http://repo.aliyun.com/api-doc/Tunnel/get_upload_session_status/index.html Get Upload Session Status
      def get_status
        path = "/projects/#{project.name}/tables/#{table_name}"

        query = { uploadid: upload_id }
        query.merge!(partition: partition_spec) if partition_spec

        resp = client.get(path, query: query)

        result = resp.parsed_response
        result.is_a?(String) ? JSON.parse(result) : result
      end

      # Complete a upload session
      #
      # @see http://repo.aliyun.com/api-doc/Tunnel/post_commit_upload_session/index.html Post commit Upload Session
      #
      # @params options [Hash] options
      # @option options [String] :tunnel_version specify the Tunnel API verion
      def complete(options = {})
        Utils.stringify_keys!(options)
        path = "/projects/#{project.name}/tables/#{table_name}"

        query = { uploadid: upload_id }
        query.merge!(partition: partition_spec) if partition_spec

        headers = {}
        headers.merge!( "x-odps-tunnel-version" => options["tunnel_version"] ) if options.key?('tunnel_version')

        !!client.post(path, query: query, headers: headers)
      end

    end
  end
end
