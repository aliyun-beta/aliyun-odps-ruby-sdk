## Tables

Table is the basic unit for data access in ODPS.


### Basic

To List all your tables:

    project.tables.list


To Get single Table:    

    table = project.tables.get('table_name') # project.tables.table('table_name')
    
    irb(main):009:0> table.schema
    => #<Aliyun::Odps::TableSchema:0x007f90b3dca3c0 @columns=[#<Aliyun::Odps::TableColumn:0x007f90b3dca140 @comment="", @label="", @name="uuid", @type="bigint">, #<Aliyun::Odps::TableColumn:0x007f90b3dc98a8 @comment="", @label="", @name="name", @type="string">]>
    irb(main):010:0> table.creation_time
    => Wed, 23 Dec 2015 13:46:08 +0000
    irb(main):011:0> table.owner
    => "ALIYUN$owner@email.com"
    irb(main):012:0> table.comment
    => nil
    

### Create Table

Before create table, you must create a schema.

    schema = Aliyun::Odps::TableSchema.new(
      columns: [{name: 'uuid', type: 'bigint'}, {name: 'username', type: 'string'}],
      partitions: [{name: 'city', type: 'string'}]
    )

Or just get schema from other table and modify:

     table = project.tables.get('target_table_name')
     schema = table.schema
     
     schema.columns << Aliyun::Odps::TableColumn.new(name: 'password', type: 'string')
     schema.partitions = []

Then you can create table:

    project.tables.create('test_table', schema)
    

### Delete Table  

To deleta table, just use `tables#delete`

    project.tables.delete('table_name')
    

### Partition

In ODPS, you can contains partitions for table:

To list all exist partitions:

    partitions = table.table_partitions.list

To create partition:    

    partition = table.table_partitions.create(city: 'hangzhou')

To delete a exist partition:

    partition = table.table_partitions.delete(city: 'hangzhou') 

***Note: if create partition or delete partition fail, it will raise Aliyun::Odps::InstanceTaskNotSuccessError, check your partition value is match the schema defined when create table***       
    

Ok, Tables is over, let's go to [resources](./resources.md)  