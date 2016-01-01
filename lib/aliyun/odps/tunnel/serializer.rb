require 'stringio'
require 'protobuf'
require 'aliyun/odps/crc/crc'
require 'aliyun/odps/tunnel/tunnel_table'

module Aliyun
  module Odps
    $TUNNEL_META_COUNT = 33_554_430 #  magic num 2^25-2
    $TUNNEL_META_CHECKSUM = 33_554_431 #  magic num 2^25-1
    $TUNNEL_END_RECORD = 33_553_408 #  maigc num 2^25-1024

    class Serializer
      def encodeBool(value)
        [value ? 1 : 0].pack('C')
      end

      def encodeDouble(value)
        [value].pack('E')
      end

      def encodeSInt64(value)
        if value >= 0
          ::Protobuf::Field::VarintField.encode(value << 1)
        else
          ::Protobuf::Field::VarintField.encode(~(value << 1))
        end
      end

      def encodeUInt32(value)
        return [value].pack('C') if value < 128
        bytes = []
        until value == 0
          bytes << (0x80 | (value & 0x7f))
          value >>= 7
        end
        bytes[-1] &= 0x7f
        bytes.pack('C*')
      end

      def encodeDataTime(value)
        encodeSInt64(value)
      end

      def encodeString(value)
        value_to_encode = value.dup
        # value_to_encode.encode!(::Protobuf::Field::StringField::ENCODING, :invalid => :replace, :undef => :replace, :replace => "")
        value_to_encode.force_encoding(::Protobuf::Field::BytesField::BYTES_ENCODING)
        string_bytes = ::Protobuf::Field::VarintField.encode(value_to_encode.size)
        string_bytes << value_to_encode
      end

      def encodeFixed64(value)
        # we don't use 'Q' for pack/unpack. 'Q' is machine-dependent.
        [value & 0xffff_ffff, value >> 32].pack('VV')
      end

      def encodeFixed32(value)
        [value].pack('V')
      end

      def encodeFixedString(value)
        [value].pack('V')
      end

      def writeTag(idx, type, stream)
        key = (idx << 3) | type
        stream << ::Protobuf::Field::VarintField.encode(key)
      end

      def self.parse(content, schema = nil)
        io = StringIO.new(content.to_s) unless content.kind_of?(StringIO)
        records = []
        record = [] # temp record, keep the order from server side
        until io.eof?
          key, value = ::Protobuf::Decoder.read_field(io)
          if key == $TUNNEL_END_RECORD
            records << record.pop(record.length)
          else
            record << value
          end
        end
        records
      end

      def serialize(upStream, recordList)
        crc32cPack = StringIO.new
        if recordList.is_a? Array
          recordList.each do |record|
            crc32cRecord = StringIO.new
            schema = OdpsTableSchema.new
            schema = record.getTableSchema
            schema.mCols.each do |col|
              cellValue = record.getValue(col.mIdx)
              next if cellValue.nil?
              crc32cRecord.write(encodeFixed32(col.mIdx + 1))
              case col.mType
              when $ODPS_BIGINT
                crc32cRecord.write(encodeFixed64(cellValue))
                writeTag(col.mIdx + 1, ::Protobuf::WireType::VARINT, upStream)
                upStream.write(encodeSInt64(cellValue))
              when $ODPS_DOUBLE
                crc32cRecord.write(encodeDouble(cellValue))
                writeTag(col.mIdx + 1, ::Protobuf::WireType::FIXED64, upStream)
                upStream.write(encodeDouble(cellValue))
              when $ODPS_BOOLEAN
                crc32cRecord.write(encodeBool(cellValue))
                writeTag(col.mIdx + 1, ::Protobuf::WireType::VARINT, upStream)
                upStream.write(encodeBool(cellValue))
              when $ODPS_DATETIME
                crc32cRecord.write(encodeFixed64(cellValue))
                writeTag(col.mIdx + 1, ::Protobuf::WireType::VARINT, upStream)
                upStream.write(encodeDataTime(cellValue))
              when $ODPS_STRING
                crc32cRecord.write(cellValue)
                writeTag(col.mIdx + 1, ::Protobuf::WireType::LENGTH_DELIMITED, upStream)
                upStream.write(encodeString(cellValue))
              when $ODPS_DECIMAL
                crc32cRecord.write(cellValue)
                writeTag(col.mIdx + 1, ::Protobuf::WireType::LENGTH_DELIMITED, upStream)
                upStream.write(encodeString(cellValue))
              else
                fail 'invalid mType'
              end
            end
            recordCrc = CrcCalculator.calculate(crc32cRecord)
            writeTag($TUNNEL_END_RECORD, ::Protobuf::WireType::VARINT, upStream)
            upStream.write(encodeUInt32(recordCrc))
            crc32cPack.write(encodeFixed32(recordCrc))
          end
          writeTag($TUNNEL_META_COUNT, ::Protobuf::WireType::VARINT, upStream)
          upStream.write(encodeSInt64(recordList.size))
          writeTag($TUNNEL_META_CHECKSUM, ::Protobuf::WireType::VARINT, upStream)
          upStream.write(encodeUInt32(CrcCalculator.calculate(crc32cPack)))
        else
          fail 'param must be a array'
        end
      end
    end
end
end
