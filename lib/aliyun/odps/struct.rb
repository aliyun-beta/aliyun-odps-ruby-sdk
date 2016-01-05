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

            define_reader_method(attr)
            define_writer_method(attr, type, options)
          end

          private

          def define_reader_method(attr)
            attr_reader attr
          end

          def define_writer_method(attr, type, options)
            init_with_block =
              if options.key?(:init_with) && options[:init_with].respond_to?(:call)
                options[:init_with]
              else
                build_block_with_type(attr, type, options)
              end
            define_writer_method_with_block(attr, init_with_block)
          end

          def build_block_with_type(attr, type, options)
            case type.to_s
            when 'Integer'
              build_integer_block(attr, options)
            when 'DateTime'
              build_datetime_block(attr, options)
            when 'String'
              build_string_block(attr, options)
            else
              build_default_block(attr, options)
            end
          end

          def build_string_block(attr, options)
            if options.key?(:within) && options[:within].is_a?(Array)
              build_block_with_within(attr, options)
            else
              build_default_block(attr, options)
            end
          end

          def build_block_with_within(attr, options)
            proc do |value|
              if options[:within].include?(value.to_s)
                value
              else
                fail ValueNotSupportedError.new(attr, options[:within])
              end
            end
          end

          def build_integer_block(attr, options)
            proc { |value| value.to_i }
          end

          def build_datetime_block(attr, options)
            proc { |value| DateTime.parse(value) }
          end

          def build_default_block(attr, options)
            proc { |value| value }
          end

          def define_writer_method_with_block(attr, block)
            define_method("#{attr}=") do |value|
              instance_eval do
                instance_variable_set("@#{attr}", block.call(value))
              end
            end
          end
        end
      end
    end
  end
end
