require 'aliyun/odps/clients/instances'
require 'aliyun/odps/clients/tables'
require 'aliyun/odps/clients/resources'
require 'aliyun/odps/clients/functions'

module Aliyun
  module Odps
    module Clients
      # Methods for Projects
      module Projects
        # List all projects
        #
        # @see http://repo.aliyun.com/api-doc/Project/get_projects/index.html Get projects
        #
        # @params options [Hash] options
        # @option options [String] :owner specify the project owner
        # @option options [String] :marker specify marker for paginate
        # @option options [String] :maxitems (1000) specify maxitems in this request
        #
        # @return [Aliyun::Odps::List]
        #
        # TODO: http://git.oschina.net/newell_zlx/aliyun-odps-ruby-sdk/issues/2
        def list(options = {})
          Utils.stringify_keys!(options)
          query = Utils.hash_slice(options, 'owner', 'marker', 'maxitems')
          resp = client.get('/projects', query: query)
          result = resp.parsed_response

          Aliyun::Odps::List.build(result, %w(Projects Project)) do |hash|
            Struct::Project.new(hash.merge(client: Aliyun::Odps::Client.instance))
          end
        end

        # Get Project Information
        #
        # @see http://repo.aliyun.com/api-doc/Project/get_project/index.html Get Project
        #
        # @params name specify the project name
        def get(name)
          result = client.get("/projects/#{name}").parsed_response
          hash = Utils.dig_value(result, 'Project')
          Struct::Project.new(hash.merge(client: Aliyun::Odps::Client.instance))
        end

        # Update Project Information
        #
        # @see http://repo.aliyun.com/api-doc/Project/put_project/index.html Put Project
        #
        # @params name specify the project name
        # @params options [Hash] options
        # @option options [String] :comment Comment of the project
        def update(name, options = {})
          Utils.stringify_keys!(options)
          project = Struct::Project.new(
            name: name,
            comment: options['comment'],
            client: Aliyun::Odps::Client.instance
          )
          body = project.build_update_body
          !!client.put("/projects/#{name}", body: body)
        end
      end
    end
  end
end
