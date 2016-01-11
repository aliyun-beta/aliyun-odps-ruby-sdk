## Resources

Resources is a important part for ODPS.

To List all resources:

    project.resources.list
    
In ODPS, resource type can be: py, jar, archive, file and table.

### Create Resource


#### file resource

py, jar, archive, file are file resource, now let's take a look for below example to create a file resource:

    resource = project.resources.create('file', 'test_file_resource', file: "path/to/resource.rb")
    
    # or
    
    resource = project.resources.create('file', 'test_file_resource', file: "puts 'hello world'")


#### Table resource

To create a resource with exist table exist in project, pass table with table path:

    resource = project.resources.create('table', 'test_table_resource', table: "test_table partition(partname='part1')")

please note the table argument format: 

+ "tablename partition(col=value,[col=value])" for table with partition
+ "tablename" for table without any partitions

### Get Resource

To get resource content:

    resource = project.resources.get('test_file_resource')
    
    File.open(resource.name, "w") do |f|
      f.write resource.content
    end

To get resource information except content:

    resource = project.resources.head('test_file_resource')


### Others

Besides, you can update resource:

    resource = project.resources.update('file', 'test_file_resource', file: "puts 'hello rio'")    

To delete a resource:

    project.resources.delete('test_file_resource')
    
    
After resource, let's visit [Functions](./functions.md)    