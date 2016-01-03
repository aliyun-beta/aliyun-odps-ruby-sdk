module Aliyun
  module Odps
    module Struct
      class Base
        def initialize(attributes = {})
          attributes.each do |key, value|
            m = "#{Utils.underscore(key)}=".to_sym
            send(m, value) if self.respond_to?(m)
          end

          validate_required
        end

        def validate_required
          missing_attrs = []
          (self.class.required_attrs || []).each do |attr|
            missing_attrs.push(attr) if send(attr).nil?
          end
          fail "Missing attribute: #{missing_attrs.join(',')}" unless missing_attrs.empty?
        end
        private :validate_required

        def update_attrs(attrs)
          attrs.each do |k, v|
            send("#{Utils.underscore(k)}=", v)
          end
          self
        end

        def client
          project.client
        end

        class << self
          attr_reader :required_attrs

          # @!macro [attach] property
          #   @!attribute [rw] $1
          #   @return [$2]
          #
          # @example
          #
          #  property :name, String, required: true, init_with: proc {|value| value.upcase }, within: %w{value1 value2}
          #
          # @params options [Hash] options
          # @option options [Boolean] :required required or optional
          # @option options [block] :init_with block used to init attr
          def property(attr, type, options = {})
            @required_attrs ||= []
            @required_attrs << attr.to_s if options[:required]

            attr_reader attr

            init_with_block =
              if options.key?(:init_with) && options[:init_with].respond_to?(:call)
                init_with_block = options[:init_with]
              else
                case type.to_s
                when 'Integer'
                  proc { |value| value.to_i }
                when 'DateTime'
                  proc { |value| DateTime.parse(value) }
                when 'String'
                  if options.key?(:within) && options[:within].is_a?(Array)
                    proc do |value|
                      fail ValueNotSupportedError.new(attr, options[:within]) unless options[:within].include?(value.to_s)
                      value
                    end
                  else
                    proc { |value| value }
                  end
                else
                  proc { |value| value }
                end
              end

            define_method("#{attr}=") do |value|
              instance_eval do
                instance_variable_set("@#{attr}", init_with_block.call(value))
              end
            end
          end
        end
      end
    end
  end
end
