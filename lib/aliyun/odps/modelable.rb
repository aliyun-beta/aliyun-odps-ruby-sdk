require 'active_support/all'
require 'aliyun/odps/service_object'

module Aliyun
  module Odps
    module Modelable
      def has_many(models, _opts = {})
        mod = models.to_s.singularize
        klass = "Aliyun::Odps::#{mod.camelize}s".constantize
        define_method(models) do
          klass.build(self)
        end
      end
    end
  end
end
