module Aliyun
  module Odps
    $STRING_MAX_LENTH = 8 * 1024 * 1024
    $DATETIME_MAX_TICKS = 253_402_271_999_000
    $DATETIME_MIN_TICKS = -62_135_798_400_000
    $STRING_CHARSET = 'UTF-8'
    class OdpsTableRecord
      attr_reader :mValues, :mSchema

      def initialize(schema)
        @mSchema = schema
        @mValues = Array.new(@mSchema.getColumnCount)
      end

      def getColumnsCount
        @mSchema.getColumnCount
      end

      def getTableSchema
        @mSchema
      end

      def getValue(idx)
        fail 'idx out of range' if idx < 0 || idx >= @mSchema.getColumnCount
        @mValues.at(idx)
      end

      def setNullValue(idx)
        setValue(idx, nil)
      end

      def setBigInt(idx, value)
        if value.is_a? Integer
          setValue(idx, value)
        elsif value.is_a? String
          setValue(idx, value.to_i)
        else
          fail 'value show be Integer, idx:' + idx.to_s + ' value:' + value.to_s
        end
      end

      def setDouble(idx, value)
        if value.is_a? Float
          setValue(idx, value)
        elsif value.is_a? String
          setValue(idx, value.to_f)
        else
          fail 'value show be Float, idx:' + idx.to_s + ' value:' + value.to_s
        end
      end

      def setBoolean(idx, value)
        if value.is_a? String
          if value == 'true'
            setValue(idx, true)
          elsif value == 'false'
            setValue(idx, false)
          else
            fail 'value must be true or false, idx:' + idx.to_s + ' value:' + value.to_s
          end
        elsif value != false && value != true
          fail 'value must be bool or string[true,false], idx:' + idx.to_s + ' value:' + value.to_s
        end
        setValue(idx, value)
      end

      def setDateTime(idx, value)
        if value.is_a?(Integer) && value >= $DATETIME_MIN_TICKS && value <= $DATETIME_MAX_TICKS
          setValue(idx, value)
        elsif value.is_a?(DateTime) || value.is_a?(Time)
          if value.to_i * 1000 >= $DATETIME_MIN_TICKS && value.to_i * 1000 <= $DATETIME_MAX_TICKS
            setValue(idx, value.to_i * 1000)
          else
            fail 'DateTime out of range or value show be Integer and between -62135798400000 and 253402271999000.'
          end
        elsif value.is_a? String
          begin
            tmpTime = Time.parse(value)
            setValue(idx, tmpTime.to_i * 1000)
          rescue
            raise 'Parse string to datetime failed, string:' + value
          end
        else
          fail 'DateTime cell should be in Integer or Time or DateTime format, idx:' + idx.to_s + ' value:' + value.to_s
        end
      end

      def setDecimal(idx, value)
        if value.is_a? String
          setValue(idx, value)
        elsif value.is_a? Float
          setValue(idx, value.to_s)
        elsif value.is_a? BigDecimal
          setValue(idx, value.to_s)
        else
          fail 'value can not be convert to decimal, idx:' + idx.to_s + ' value:' + value.to_s
        end
      end

      def setString(idx, value)
        if value.is_a?(String) && value.length < $STRING_MAX_LENTH
          setValue(idx, value)
        else
          fail 'value show be String and len < ' + $STRING_MAX_LENTH.to_s + ', idx:' + idx.to_s + ' value:' + value.to_s
        end
      end

      private

      def setValue(idx, value)
        if idx < 0 || idx >= @mSchema.getColumnCount
          fail 'idx out of range, idx:' + idx.to_s + ' value:' + value.to_s
        end
        @mValues[idx] = value
      end
    end

    $ODPS_BIGINT = 'bigint'
    $ODPS_DOUBLE = 'double'
    $ODPS_BOOLEAN = 'boolean'
    $ODPS_DATETIME = 'datetime'
    $ODPS_STRING = 'string'
    $ODPS_DECIMAL = 'decimal'

    class OdpsTableColumn
      attr_reader :mName, :mType, :mIdx
      def initialize(name, type, idx)
        @mName = name
        @mType = type
        @mIdx = idx
      end
    end

    class OdpsTableSchema
      attr_accessor :mCols
      def initialize(jsonobj = nil)
        @mCols = []
        unless jsonobj.nil?
          columns = jsonobj['columns']
          columns.each do |object|
            appendColumn(object['name'], object['type'])
          end
        end
      end

      def getColumnCount
        @mCols.size
      end

      def getColumnType(idx)
        fail 'idx out of range' if idx < 0 || idx >= @mCols.size
        @mCols.at(idx).mType
      end

      def appendColumn(name, type)
        col = OdpsTableColumn.new(name, type, @mCols.size)
        @mCols.push(col)
      end
    end
end
end
