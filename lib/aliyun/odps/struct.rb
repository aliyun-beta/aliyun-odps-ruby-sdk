module Aliyun
  module Odps
    module Struct
      class Base
        def initialize(attributes = {})
          attributes.each do |key, value|
            m = "#{Utils.underscore(key)}=".to_sym
            send(m, value) if self.respond_to?(m)
          end
        end
      end
    end
  end
end

Dir[File.join(File.dirname(__FILE__), 'struct/*.rb')].each { |f| require f }
