## Table Tunnel

In ODPS, Tunnel Service is used for sync data between different database and data sync tool with ODPS.

Each Tunnel Restful API is no status, they are all synchronized.

more about [Tunnel information](http://repo.aliyun.com/api-doc/Tunnel/tunnel_brief/index.html)


### Basic

some topic:

+ Session: a whole upload or download process is a session.
+ Request: in a session, each visit to API is a Request, a session contains many requests.

#### Upload

A Whole upload contains three steps:

1. init upload session
2. upload data
3. complete upload session


Show me the code:

If you have a table with below schema:

	{
	    columns: [
	      { name: 'uuid', type: 'bigint' },
	      { name: 'username', type: 'string' },
	      { name: 'password', type: 'string' },
	    ]
	}
	
    upload_session = project.table_tunnels.init_upload_session('table_name', { part: 'value' })
    
    upload_session.upload(1, [[1, 'Jack', 'jackpass'], [2, 'Smith', 'smithpass']])
    
    upload_session.upload(1, [[1, 'Jack', 'jackpass']])  # replace the block 1
    
    upload_session.complete
    

when you upload a block with exist block id, it will replace old data. block id can range from 0~1999

Here, I think the most important thing is the format for the content, here, I want you provide a array and each element is also a array with your schema order.
    
That's it, enjoy!    

#### Download

A Whole download contains two steps:

1. init download session
2. download data


Example:

    download_session = project.table_tunnels.init_download_session('table_name, { part: 'value' })
    
    content = download_session.download("(1,100)", "uuid,username,password")
    
    puts [[1, 'Jack', 'jackpass'], [2, 'Smith', 'smithpass']]


Now, All is covered, Let's view the [Error Code](./error.md)    
    

