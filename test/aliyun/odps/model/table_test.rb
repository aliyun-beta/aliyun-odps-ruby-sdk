require 'test_helper'

describe Aliyun::Odps::Table do
  let(:table) { Aliyun::Odps::Table.new(name: 'table1', project: project) }

  describe 'partitions' do
    it 'should get partitions information' do
      query = { maxitems: 2, marker: 'cGFydDE9cGFydDEh' }
      stub_client_request(
        :get,
        "#{endpoint}/projects/#{project_name}/tables/table1",
        {
          query: {
            partitions: true,
            expectmarker: true
          }.merge(query)
        },
        file_path: 'tables/partitions.xml',
        headers: {
          content_type: 'application/xml'
        }
      )

      obj = table.partitions(query)

      assert_kind_of(Aliyun::Odps::List, obj)
      assert_equal(nil, obj.marker)
      assert_equal(2, obj.max_items)
      assert_equal({ 'sale_date' => '20150915', 'region' => 'USA' }, obj[0])
      assert_equal({ 'sale_date' => '20150916', 'region' => 'CHINA' }, obj[1])
    end

    it 'should raise RequestError' do
      stub_fail_request(:get, %r{/projects/#{project_name}/tables/table1})
      assert_raises(Aliyun::Odps::RequestError) { table.partitions }
    end
  end
end
