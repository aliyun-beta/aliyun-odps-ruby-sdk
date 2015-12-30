require 'active_support/all'
require 'aliyun/odps/service_object'

module Aliyun
  module Odps
    module Modelable
      def has_many(models, _opts = {})
        # p "#{models.to_s.singularize.camelize}"
        mod = models.to_s.singularize
        klass = "Aliyun::Odps::#{mod.camelize}s".constantize
        define_method(models) do
          klass.build(self)
        end
        # if opts[:actions]
        #   opts[:actions].each do |action|
        #     action = action.to_s
        #     define_method("#{action}_#{mod}") {|options = {}|
        #       raise "Can't #{action} object without params" if options.empty?
        #       klass.send(action, options)
        #     }
        #   end
        # end
      end
    end
  end
end
