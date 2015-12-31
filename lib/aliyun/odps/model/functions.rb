module Aliyun
  module Odps
    # Methods for Functions
    class Functions < ServiceObject
      # List Functions of project
      #
      # @see http://repo.aliyun.com/api-doc/Function/get_functions/index.html Get functions
      #
      # @param options [Hash] options
      # @option options [String] :name specify function name
      # @option options [String] :owner specify function owner
      # @option options [String] :marker
      # @option options [String] :maxitems (1000)
      #
      # @return [List]
      def list(options = {})
        Utils.stringify_keys!(options)
        path = "/projects/#{project.name}/registration/functions"
        query = Utils.hash_slice(options, 'name', 'owner', 'marker', 'maxitems')
        result = client.get(path, query: query).parsed_response

        Aliyun::Odps::List.build(result, %w(Functions Function)) do |hash|
          Function.new(hash)
        end
      end

      # Get Function
      #
      # @param name specify function name
      #
      # @return [Function]
      def get(name)
        path = "/projects/#{project.name}/registration/functions/#{name}"

        result = client.get(path).parsed_response
        Function.new(Utils.dig_value(result, 'Function'))
      end
      alias_method :function, :get

      # Register function in project
      #
      # @see http://repo.aliyun.com/api-doc/Function/post_function/index.html Post function
      #
      # @param name [String] specify function name
      # @param class_path [String] specify class Path used by function
      # @param resources [Array<Model::Resource>] specify resources used by function
      #
      # @return [Function]
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
      # @param name [String] specify function name
      # @param class_path [String] specify class Path used by function
      # @param resources [Array<Model::Resource>] specify resources used by function
      #
      # @return [true]
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
      # @param name [String] specify function name
      #
      # @return [true]
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
