module Aliyun
  module Odps
    class Resource < Struct::Base
      extend Aliyun::Odps::Modelable

      property :name, String, required: true
      property :owner, String
      property :last_updator, String
      property :comment, String
      property :resource_type, String, within: %w(py jar archive file table)
      property :local_path, String
      property :creation_time, DateTime
      property :last_modified_time, DateTime
      property :table_name, String
      property :resource_size, Integer
      property :content, String
      property :location, String

      alias_method :resource_name=, :name=

      def to_hash
        { 'ResourceName' => name }
      end
    end
  end
end
