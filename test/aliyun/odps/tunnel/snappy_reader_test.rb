# encoding: utf-8
require 'test_helper'
require 'odps_protobuf'

describe Aliyun::SnappyReader do

  it "should uncompress data" do
    schema = {"columns"=>[{"name"=>"uuid", "type"=>"bigint"}, {"name"=>"name", "type"=>"string"}]}
    deserializer = OdpsProtobuf::Deserializer.new
    assert_equal([[2, "name1"], [1, "jin"], [100, "zhuzhuzhu"], [1, "jz"], [123, "Jack"], [124, "Smith"]], deserializer.deserialize(Aliyun::SnappyReader.uncompress("\xFF\x06\x00\x00sNaPpY\x00x\x00\x00\x84\x8Al\xF0{`\b\x04\x12\x05name1\x80\xC0\xFF\x7F\x84\x9D\x91\x9F\a\b\x02\x12\x03jin\x01\x100\xA2\x85\xAF\xCD\x02\b\xC8\x01\x12\tzhu\t\x03\x01\x17(\xA4\xF9\x9F\xA3\b\b\x02\x12\x02jz\x01\x0F4\xEF\xA1\xC2\xCB\x06\b\xF6\x01\x12\x04Jack\x01\x128\xD1\x99\x82\xE6\f\b\xF8\x01\x12\x05Smith\x01\x13H\xFB\xB3\xD2\x97\x05\xF0\xFF\xFF\x7F\f\xF8\xFF\xFF\x7F\x87\xC4\x8A\x9C\x04"), schema))
  end
end
