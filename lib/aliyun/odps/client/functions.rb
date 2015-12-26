module Aliyun
  module Odps
    class Client
      # Methods for Functions
      module Functions
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
          path = "/projects/#{client.current_project}/registration/functions"
          query = Utils.hash_slice(options, 'name', 'owner', 'marker', 'maxitems')
          result = client.get(path, query: query).parsed_response

          keys = %w(Functions Function)
          Utils.wrap(Utils.dig_value(result, *keys)).map do |hash|
            Struct::Function.new(hash)
          end
        end

        # Register function in project
        #
        # @see http://repo.aliyun.com/api-doc/Function/post_function/index.html Post function
        #
        # @params name [String] specify function name
        # @params class_type [String] specify class Path used by function
        # @params resources [Array<Struct::Resource>] specify resources used by function
        def create(name, class_type, resources = [])
          path = "/projects/#{client.current_project}/registration/functions"
          body = XmlGenerator.generate_create_function_xml(name, class_type, resources)
          !!client.post(path, body: body)
        end

        # Update function in project
        #
        # @see http://repo.aliyun.com/api-doc/Function/put_function/index.html Put function
        #
        # @params name [String] specify function name
        # @params class_type [String] specify class Path used by function
        # @params resources [Array<Struct::Resource>] specify resources used by function
        def update(name, class_type, resources = [])
          path = "/projects/#{client.current_project}/registration/functions/#{name}"
          body = XmlGenerator.generate_create_function_xml(name, class_type, resources)
          !!client.put(path, body: body)
        end

        # Delete function in project
        #
        # @see http://repo.aliyun.com/api-doc/Function/delete_function/index.html Delete function
        #
        # @params name [String] specify function name
        def delete(name)
          path = "/projects/#{client.current_project}/registration/functions/#{name}"
          !!client.delete(path)
        end
      end
    end

  end
end
