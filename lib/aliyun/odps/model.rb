require 'active_support/all'

module Aliyun
  module Odps
    class Model
      class << self

        def client
          Aliyun::Odps::Client.instance
        end

        def has_many(models, opts = {})
          # p "#{models.to_s.singularize.camelize}"
          mod = models.to_s.singularize
          klass = "Aliyun::Odps::#{mod.camelize}".constantize
          define_method(models) { |options = {}|
            options ||= {}
            klass.list(options)
          }
          if opts[:actions]
            opts[:actions].each do |action|
              action = action.to_s
              define_method("#{action}_#{mod}") {|options = {}|
                raise "Can't #{action} object without params" if options.empty?
                klass.send(action, options)
              }
            end
          end
        end
      end

      def update(options)
        self.class.update(options)
      end
    end
  end
end
