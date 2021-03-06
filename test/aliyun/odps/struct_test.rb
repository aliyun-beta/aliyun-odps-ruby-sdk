require 'test_helper'
require 'timecop'

describe Aliyun::Odps::Struct do
  before do
    class Foo < Aliyun::Odps::Struct::Base
      property :init_with_name, :String, init_with: proc { |value| value.upcase }
      property :integer_name, :Integer
      property :datetime_name, :DateTime
      property :string_name, :String
      property :required_name, :String, required: true
      property :within_name, :String, within: %w(value1 value2)
    end
  end

  it 'should define attr' do
    Timecop.freeze('2015-10-12T10:01:30') do
      assert_raises(RuntimeError) { Foo.new }

      foo = Foo.new(required_name: 'require me')

      foo.init_with_name = 'test'
      assert_equal('TEST', foo.init_with_name)

      foo.integer_name = '23'
      assert_equal(23, foo.integer_name)

      foo.datetime_name = '2015-10-12T10:01:30'
      assert_kind_of(DateTime, foo.datetime_name)
      assert_equal('2015-10-12T10:01:30+00:00', foo.datetime_name.to_s)

      foo.string_name = '2015-10-12T10:01:30'
      assert_kind_of(String, foo.string_name)
      assert_equal('2015-10-12T10:01:30', foo.string_name)

      foo.within_name = 'value1'
      assert_equal('value1', foo.within_name)

      error = assert_raises(Aliyun::Odps::ValueNotSupportedError) { foo.within_name = 'noexistvalue' }
      assert_equal('within_name only support: value1, value2 !!', error.message)
    end
  end
end
