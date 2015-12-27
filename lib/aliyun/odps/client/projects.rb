require 'aliyun/odps/client/instances'
require 'aliyun/odps/client/tables'
require 'aliyun/odps/client/resources'
require 'aliyun/odps/client/functions'

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
        # @option options [String] :marker
        # @option options [String] :maxitems (1000)
        #
        # @return [Aliyun::Odps::List]
        #
        # TODO: http://git.oschina.net/newell_zlx/aliyun-odps-ruby-sdk/issues/2
        def list(options = {})
          Utils.stringify_keys!(options)
          query = Utils.hash_slice(options, 'owner', 'marker', 'maxitems')
          resp = client.get('/projects', query: query)
          result = resp.parsed_response

          keys = %w(Projects Project)
          marker = Utils.dig_value(result, 'Projects', 'Marker')
          max_items = Utils.dig_value(result, 'Projects', 'MaxItems')
          projects = Utils.wrap(Utils.dig_value(result, *keys)).map do |hash|
            Struct::Project.new(hash.merge(client: Aliyun::Odps::Client.instance))
          end
          Aliyun::Odps::List.new(marker, max_items, projects)
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
          body = XmlGenerator.generate_update_project_xml(name, options)
          !!client.put("/projects/#{name}", body: body)
        end
      end
    end
  end
end
