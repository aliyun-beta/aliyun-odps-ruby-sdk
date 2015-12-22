module Aliyun
  module Odps
    class Client
      # Methods for Projects
      module Projects
        # List all projects
        #
        # @see http://repo.aliyun.com/api-doc/Project/get_projects/index.html Get projects
        #
        # @params options [Hash] options
        # @option options [String] :owner specify the project owner
        # @option options [String] :Marker
        # @option options [String] :MaxItems (1000)
        def list(options = {})
          Utils.stringify_keys!(options)
          query = Utils.hash_slice(options, 'owner', 'Marker', 'MaxItems')
          client.get('/projects', query: query)
        end
      end
    end
  end
end
