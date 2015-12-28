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

        class << self
          attr_reader :required_attrs

          # @example
          #
          #  def_attr :name, :String, required: true, init_with: Proc.new {|value| value.upcase }
          #
          # @params options [Hash] options
          # @option options [Boolean] :required required or optional
          # @option options [block] :init_with block used to init attr
          def def_attr(attr, type, options = {})
            @required_attrs ||= []
            @required_attrs << attr.to_s if options[:required]

            attr_reader attr

            init_with_block =
              if options.key?(:init_with) && options[:init_with].respond_to?(:call)
                init_with_block = options[:init_with]
              else
                case type.to_s
                when 'Integer'
                  Proc.new { |value| value.to_i }
                when 'DateTime'
                  Proc.new { |value| DateTime.parse(value) }
                else
                  Proc.new { |value| value }
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

Dir[File.join(File.dirname(__FILE__), 'struct/*.rb')].each { |f| require f }
