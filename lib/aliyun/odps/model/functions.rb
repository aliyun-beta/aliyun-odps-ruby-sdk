module Aliyun
  module Odps
    # Methods for Functions
    class Functions < ServiceObject
      # List Functions of project
      #
      # @see http://repo.aliyun.com/api-doc/Function/get_functions/index.html Get functions
      #
      # @params options [Hash] options
      # @option options [String] :name specify function name
      # @option options [String] :owner specify function owner
      # @option options [String] :marker
      # @option options [String] :maxitems (1000)
      def list(options = {})
        Utils.stringify_keys!(options)
        path = "/projects/#{project.name}/registration/functions"
        query = Utils.hash_slice(options, 'name', 'owner', 'marker', 'maxitems')
        result = client.get(path, query: query).parsed_response

        Aliyun::Odps::List.build(result, %w(Functions Function)) do |hash|
          Function.new(hash)
        end
      end

      # Register function in project
      #
      # @see http://repo.aliyun.com/api-doc/Function/post_function/index.html Post function
      #
      # @params name [String] specify function name
      # @params class_path [String] specify class Path used by function
      # @params resources [Array<Model::Resource>] specify resources used by function
      def create(name, class_path, resources = [])
        path = "/projects/#{project.name}/registration/functions"

        function = Function.new(
          name: name,
          class_type: class_path,
          resources: resources
        )

        resp = client.post(path, body: build_create_body(function))

        function.tap do |obj|
          obj.location = resp.headers['Location']
        end
      end

      # Update function in project
      #
      # @see http://repo.aliyun.com/api-doc/Function/put_function/index.html Put function
      #
      # @params name [String] specify function name
      # @params class_path [String] specify class Path used by function
      # @params resources [Array<Model::Resource>] specify resources used by function
      def update(name, class_path, resources = [])
        path = "/projects/#{project.name}/registration/functions/#{name}"

        function = Function.new(
          name: name,
          class_type: class_path,
          resources: resources
        )
        !!client.put(path, body: build_create_body(function))
      end

      # Delete function in project
      #
      # @see http://repo.aliyun.com/api-doc/Function/delete_function/index.html Delete function
      #
      # @params name [String] specify function name
      def delete(name)
        path = "/projects/#{project.name}/registration/functions/#{name}"
        !!client.delete(path)
      end

      private

      def build_create_body(function)
        fail XmlElementMissingError, 'ClassType' if function.class_type.nil?
        fail XmlElementMissingError, 'Resources' if function.resources.empty?

        Utils.to_xml(
          'Function' => {
            'Alias' => function.name,
            'ClassType' => function.class_type,
            'Resources' => function.resources.map(&:to_hash)
          }
        )
      end
    end
  end
end
