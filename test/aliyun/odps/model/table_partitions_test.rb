require 'test_helper'

describe Aliyun::Odps::TablePartitions do
  let(:table) { Aliyun::Odps::Table.new(name: 'table1', project: project) }

  describe 'list' do
    it 'should get partitions' do
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

      obj = table.table_partitions.list(query)

      assert_kind_of(Aliyun::Odps::List, obj)
      assert_equal(nil, obj.marker)
      assert_equal(2, obj.max_items)
      assert_equal({ 'sale_date' => '20150915', 'region' => 'USA' }, obj[0])
      assert_equal({ 'sale_date' => '20150916', 'region' => 'CHINA' }, obj[1])
    end

    it 'should raise RequestError' do
      stub_fail_request(:get, %r{/projects/#{project_name}/tables/table1})
      assert_raises(Aliyun::Odps::RequestError) do
        assert_kind_of Array, table.table_partitions.list
      end
    end
  end

  describe 'create' do
    before do
      Aliyun::Odps::Instance.any_instance.stubs(:wait_for_terminated).returns(true)
    end

    after do
      Aliyun::Odps::Instance.any_instance.unstub(:wait_for_terminated)
    end

    it 'should create partition' do
      Aliyun::Odps::Utils.stubs(:generate_uuid).returns('instance20151229111744707cc8')
      location = "#{endpoint}/projects/#{project_name}/instances/NewJobName"
      stub_client_request(
        :post,
        "#{endpoint}/projects/#{project_name}/instances",
        {
          file_path: 'table_partitions/create.xml'
        },
        headers: {
          Location: location
        }
      )
      stub_client_request(
        :get,
        "#{endpoint}/projects/#{project_name}/instances/NewJobName",
        {
          query: {
            'taskstatus' => true
          }
        },
        file_path: 'instances/status.xml'
      )

      obj = table.table_partitions.create('key1' => 'v1')

      assert_kind_of(Hash, obj)
    end
  end

  describe 'delete' do
    before do
      Aliyun::Odps::Instance.any_instance.stubs(:wait_for_terminated).returns(true)
    end

    after do
      Aliyun::Odps::Instance.any_instance.unstub(:wait_for_terminated)
    end

    it 'should delete partition' do
      Aliyun::Odps::Utils.stubs(:generate_uuid).returns('instance20151229111744707cc8')
      location = "#{endpoint}/projects/#{project_name}/instances/NewJobName"
      stub_client_request(
        :post,
        "#{endpoint}/projects/#{project_name}/instances",
        {
          file_path: 'table_partitions/delete.xml'
        },
        headers: {
          Location: location
        }
      )
      stub_client_request(
        :get,
        "#{endpoint}/projects/#{project_name}/instances/NewJobName",
        {
          query: {
            'taskstatus' => true
          }
        },
        file_path: 'instances/status.xml'
      )

      obj = table.table_partitions.delete('key1' => 'v1')

      assert(obj, 'should delete success')
    end
  end
end
