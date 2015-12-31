module Aliyun
  module Odps
    # Methods for Resources
    class Resources < ServiceObject
      # List resources of project
      #
      # @see http://repo.aliyun.com/api-doc/Resource/get_resources/index.html Get resources
      #
      # @params options [Hash] options
      # @option options [String] :name specify resource name
      # @option options [String] :owner specify resource owner
      # @option options [String] :marker
      # @option options [String] :maxitems (1000)
      #
      # @return [List]
      def list(options = {})
        Utils.stringify_keys!(options)
        path = "/projects/#{project.name}/resources"
        query = Utils.hash_slice(options, 'name', 'owner', 'marker', 'maxitems')
        result = client.get(path, query: query).parsed_response

        Aliyun::Odps::List.build(result, %w(Resources Resource)) do |hash|
          Resource.new(hash)
        end
      end

      # Get resource of project
      #
      # @see http://repo.aliyun.com/api-doc/Resource/get_resource/index.html Get resource
      #
      # @params name [String] specify resource name
      #
      # @return [Resource]
      def get(name)
        path = "/projects/#{project.name}/resources/#{name}"
        resp = client.get(path)

        hash = {
          name: resp.headers['x-odps-resource-name'],
          last_updator: resp.headers['x-odps-updator'],
          owner: resp.headers['x-odps-owner'],
          comment: resp.headers['x-odps-comment'],
          last_modified_time: resp.headers['Last-Modified'],
          creation_time: resp.headers['x-odps-creation-time'],
          resource_size: resp.headers['x-odps-resource-size'],
          resource_type: resp.headers['x-odps-resource-type'],
          content: resp.parsed_response
        }

        Resource.new(hash)
      end
      alias_method :resource, :get

      # Get resource information in project
      #
      # @see http://repo.aliyun.com/api-doc/Resource/head_resource/index.html Head resource
      #
      # @params name [String] specify resource name
      #
      # @return [Resource]
      def get_meta(name)
        path = "/projects/#{project.name}/resources/#{name}"
        resp = client.head(path)

        hash = {
          name: resp.headers['x-odps-resource-name'],
          last_updator: resp.headers['x-odps-updator'],
          owner: resp.headers['x-odps-owner'],
          comment: resp.headers['x-odps-comment'],
          last_modified_time: resp.headers['Last-Modified'],
          creation_time: resp.headers['x-odps-creation-time'],
          resource_size: resp.headers['x-odps-resource-size'],
          resource_type: resp.headers['x-odps-resource-type']
        }

        Resource.new(hash)
      end
      alias_method :head, :get_meta

      # Create resource in project
      #
      # @see http://repo.aliyun.com/api-doc/Resource/post_resource/index.html Post resource
      #
      # @params name [String] specify resource name
      # @params type [String] specify resource type: supported value: py, jar, archive, file, table
      # @params options [Hash] options
      # @option options [String] :comment specify resource comment
      # @option options [String] :table specify table or table partition name, if your table have partitions, must contains partition spec together with format: tab1 partition(region='bj',year='2011')
      # @option options [File|BinData] :file specify the source code or file path
      #
      # @return [Resource]
      def create(name, type, options = {})
        Utils.stringify_keys!(options)
        path = "/projects/#{project.name}/resources/"

        headers = {
          'x-odps-resource-type' => type,
          'x-odps-resource-name' => name
        }
        headers.merge!('x-odps-comment' => options['comment']) if options.key?('comment')
        headers.merge!('x-odps-copy-table-source' => options['table']) if options.key?('table')

        body = options.key?('file') ? Utils.to_data(options['file']) : ''

        fail ResourceMissingContentError if body.empty? && !options.key?('table')

        location = client.post(path, headers: headers, body: body).headers['Location']

        Resource.new(name: name, resource_type: type, comment: options['comment'], location: location)
      end

      # Update resource in project
      #
      # @see http://repo.aliyun.com/api-doc/Resource/put_resource/index.html Put resource
      #
      # @params name [String] specify resource name
      # @params type [String] specify resource type: supported value: py, jar, archive, file, table
      # @params options [Hash] options
      # @option options [String] :comment specify resource comment
      # @option options [String] :table specify table or table partition name
      # @option options [File|Bin Data] :file specify the source code or file path
      #
      # @return [true]
      def update(name, type, options = {})
        Utils.stringify_keys!(options)
        path = "/projects/#{project.name}/resources/#{name}"

        headers = {
          'x-odps-resource-type' => type,
          'x-odps-resource-name' => name
        }
        headers.merge!('x-odps-comment' => options['comment']) if options.key?('comment')
        headers.merge!('x-odps-copy-table-source' => options['table']) if options.key?('table')

        body = options.key?('file') ? Utils.to_data(options['file']) : ''

        fail ResourceMissingContentError if body.empty? && !options.key?('table')

        !!client.put(path, headers: headers, body: body)
      end

      # Delete resource in project
      #
      # @see http://repo.aliyun.com/api-doc/Resource/delete_resource/index.html Delete resource
      #
      # @params name [String] specify the resource name
      #
      # @return [true]
      def delete(name)
        path = "/projects/#{project.name}/resources/#{name}"

        !!client.delete(path)
      end
    end
  end
end
