## Instance

Instance is use created job instance, it support: SQL, SQLPLAN, MapReduce, DT, PLSQL now.

we can define different task to create instance.

+ SQL Task

To create a SQL Task:

    task = Aliyun::Odps::InstanceTask.new(name: 'SqlTask', comment: 'sql task', query: 'select * from  test_table1;', type: 'SQL')
    instance = prj.instances.create([task])
    
    # wait for it terminate
    instance.wait_for_terminated
    
    # puts the results
    task_result = instance.task_results[task.name]
    
    puts task_result.result


To create other task, just replace SQL to your expected type, note the supported list metioned before.


Want to write more powerful SQL, visit [How to use ODPS SQL](https://help.aliyun.com/document_detail/odps/SQL/summary.html?spm=5176.docodps/SQL/ddl.3.2.LdRubj)


After Instance, let's visit [Table Tunnel](./tunnels.md), which can help us upload and download data with ODPS table.