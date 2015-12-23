require 'test_helper'

describe Aliyun::Odps::Authorization do
  it 'should get authorization' do
    assert_equal 'ODPS 12CF3450006BF789F103:z7/QmEf7ZZYABY6S7GSrfSjltv8=', Aliyun::Odps::Authorization.get_authorization(
      '12CF3450006BF789F103',
      'Isdfjlkewpoerjtnsdfsdfswerweoriskdfjert=',
      verb: 'POST',
      date: 'Thu, 26 Nov 2015 08:56:57 GMT',
      path: '/projects/test_project/resources',
      headers: {
        'Content-MD5' => 'e5828c564f71fea3a12dde8bd5d27063',
        'Content-Type' => 'application/octet-stream',
        'Host' => 'http://service-corp.odps.aliyun-inc.com/api',
        'X-ODPS-resource-type' => 'file',
        'X-ODPS-resource-name' => 'test.file'
      }
    )
  end

  it 'should get authorization with query' do
    assert_equal 'ODPS 12CF3450006BF789F103:+D2xEUdh0f41uEODgJd5zqxrVMQ=', Aliyun::Odps::Authorization.get_authorization(
      '12CF3450006BF789F103',
      'Isdfjlkewpoerjtnsdfsdfswerweoriskdfjert=',
      verb: 'POST',
      date: 'Thu, 26 Nov 2015 08:56:57 GMT',
      path: '/projects/test_project/resources',
      query: {
        owner: 'ALIYUN$demo@example.com'
      },
      headers: {
        'Content-MD5' => 'e5828c564f71fea3a12dde8bd5d27063',
        'Content-Type' => 'application/octet-stream',
        'Host' => 'http://service-corp.odps.aliyun-inc.com/api',
        'X-ODPS-resource-type' => 'file',
        'X-ODPS-resource-name' => 'test.file'
      }
    )
  end
end
