## Function

We can define functions in odps, which can be used in ODPS SQL.

Function Notes:

+ create a function need name, type, resource and other resource.
+ function name should unique in project.
+ after create, function can be used in SQL.


### Basic

To list all functions:

    project.functions.list

To get function:

    project.functions.get('function_name')
    
    
### Create Function

To create a function, should create resource first:


    resource1 = project.resources.get('resource1')
    resource2 = project.resources.get('resource1')
    
    function = project.functions.create('function1', 'Path/to/Class', [resource1, resource2])
   

To delete it:

    project.functions.delete('function1')


Now, already complete, let's visit the most powerful part [Instances](./instances.md)    