require 'test_helper'
require 'timecop'

describe Aliyun::Odps::Struct do
  before do
    class Foo < Aliyun::Odps::Struct::Base
      def_attr :init_with_name, :String, init_with: Proc.new {|value| value.upcase}
      def_attr :integer_name, :Integer
      def_attr :datetime_name, :DateTime
      def_attr :string_name, :String
      def_attr :required_name, :String, required: true
    end
  end

  it "should define attr" do
    Timecop.freeze('2015-10-12T10:01:30') do
      assert_raises(RuntimeError) { Foo.new }

      foo = Foo.new(required_name: 'require me')

      foo.init_with_name = 'test'
      assert_equal('TEST', foo.init_with_name)

      foo.integer_name = '23'
      assert_equal(23, foo.integer_name)

      foo.datetime_name = '2015-10-12T10:01:30'
      assert_kind_of(DateTime, foo.datetime_name)
      assert_equal("2015-10-12T10:01:30+00:00", foo.datetime_name.to_s)

      foo.string_name = '2015-10-12T10:01:30'
      assert_kind_of(String, foo.string_name)
      assert_equal('2015-10-12T10:01:30', foo.string_name)
    end
  end

end

