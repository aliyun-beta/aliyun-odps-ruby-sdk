## ERROR Code

In our library, [RequestError]() is raised when Request fail, in which you can get ODPS ERROR CODE, Message and Request ID.

Below is the ODPS ERROR Code:

### ODPS Common ERROR Code

| CODE | Message | HTTP STATUS CODE |
|--|--|--|
|ServiceUnavailable	|Service is temporarily unavailable, Please try again later.	|	503 Service Unavailable|
|InternalServerError|	Service internal error, please try again later.|	500 Internal Server Error|
|MethodNotAllowed|	Unsupported request method.|	405 Method Not Allowed|
|MissingAuthorization|	Authorization is required.|	401 Unauthorized|
|InvalidAuthorization|	Invalid authorization.|401 Unauthorized|
|MissingContentType	|Content-type is required.|	415 Unsupported Media Type|
|InvalidContentType	|Invalid content type.	|	415 Unsupported Media Type|
|MissingContentLength|	Content-length is required.|	411 Length Required|
|ObjectAlreadyExists|	The "" has already exited.|409 Conflict|
|NoSuchObject|	Object not found-''.|404 Not found|
|NoPermission|	You haven't enough privilege to XX.|403 Forbidden|
|InvalidParameter|	Invalid parameter XX|400 Bad Request|
|InvalidStatusSetting|	Current status is . It is not allowed to set status to|409 Conflict|
|DeleteConflict|Cannot delete object which is using|409 Conflict|
|AccessDenied| Access Denied|403 Forbidden|


### SQL ERROR Code

In General, ODPS return ERROR Code with ODPS-MMCCCCX format.

Below is a table list all SQL ERROR Code:

|Code	|Severity Level	| ERROR Message|
|--|--|--|
|ODPS-0110005|	5	|	Unknown exception from metadata operation|
|ODPS-0110011|	1	|Authorization exception|
|ODPS-0110021|	1	|	Invalid parameters|
|ODPS-0110031|	1	|	Invalid object type|
|ODPS-0110041|	1	|	Invalid meta operation|
|ODPS-0110061|	1	|	Failed to run ddltask|
|ODPS-0110071|	1	|	OTS initialization exception|
|ODPS-0110081|	1	|	OTS transaction exception|
|ODPS-0110091|	1	|	OTS filtering exception|
|ODPS-0110101|	1	|OTS processing exception|
|ODPS-0110111|	1	|OTS invalid data object|
|ODPS-0110121|	1	|Unknown OTS exception|
|ODPS-0110131|	1	|	StorageDescriptor compression exception|
|ODPS-0110141|	1	|Data version exception|
|ODPS-0110999|	9	|Critical! Internal error happened in commit |operation and rollback failed, possible breach of atomicity|
|ODPS-0120005|	5	|	Unknown exception from processor|
|ODPS-0120011|	1	|Authorization exception|
|ODPS-0120021|	1	|the delimitor must be the same in wm_concat|
|ODPS-0120031|	1	|Instance has been cancelled|
|ODPS-0121011|	1	|	Invalid regular expression pattern|
|ODPS-0121021|	1	|	Regexec call failed|
|ODPS-0121035|	5	|Illegal implicit type cast|
|ODPS-0121045|	5	|	Unsupported return type|
|ODPS-0121055|	5	|	Empty argument value|
|ODPS-0121065|	5	|Argument value out of range|
|ODPS-0121075|	5	|Invalid number of arguments|
|ODPS-0121081|	1	|Illegal argument type|
|ODPS-0121095|	5	|Invalid arguments|
|ODPS-0121105|	5	|Constant argument value expected|
|ODPS-0121115|	5	|Column reference expected|
|ODPS-0121125|	5	|Unsupported function or operation|
|ODPS-0121135|	5	|Malloc memory failed|
|ODPS-0121145|	5	|	Data overflow|
|ODPS-0123019|	9	|Distributed file operation exception|
|ODPS-0123023|	3	|Unsupported reduce type|
|ODPS-0123031|	1	|Partition exception|
|ODPS-0123043|	3	|buffer overflow|
|ODPS-0123055|	5	|Script exception|
|ODPS-0123065|	5	|Join exception|
|ODPS-0123075|	5	|Hash exception|
|ODPS-0123081|	1	|Invalid datetime string|
|ODPS-0123091|	1	|Illegal type cast|
|ODPS-0123105|	5	|Job got killed|
|ODPS-0123111|	1	|format string does not match datetime string|
|ODPS-0123121|	1	|Mapjoin exception|
|ODPS-0123131|	1	|User defined function exception|
|ODPS-0130005|	5	|Unknown exception from parser|
|ODPS-0130013|	3	|	Authorization exception|
|ODPS-0130025|	5	|Failed to I/O|
|ODPS-0130031|	1	|Failed to drop table|
|ODPS-0130041|	1	|Statistics exception|
|ODPS-0130051|	1	|Exception in sub query|
|ODPS-0130061|	1	|Invalid table|
|ODPS-0130071|	1	|Semantic analysis exception|
|ODPS-0130081|	1	|Invalid UDF reference|
|ODPS-0130091|	1	|Invalid parameters|
|ODPS-0130101|	1	|	Ambiguous data type|
|ODPS-0130111|	1	|Subquery partition pruning exception|
|ODPS-0130121|	1	|Invalid argument type|
|ODPS-0130131|	1	|Table not found|
|ODPS-0130141|	1	|Illegal implicit type cast|
|ODPS-0130151|	1	|Illegal data type|
|ODPS-0130161|	1	|Parse exception|
|ODPS-0130171|	1	|Creating view exception|
|ODPS-0130181|	1	|Window function exception|
|ODPS-0130191|	1	|Invalid column or partition key|
|ODPS-0130201|	1	|View not found|
|ODPS-0130211|	1	|Table or view already exists|
|ODPS-0130221|	1	|Invalid number of arguments|
|ODPS-0130231|	1	|Invalid view|
|ODPS-0130241|	1	|Illegal union operation|
|ODPS-0130252|	2	|Cartesian product is not allowed|
|ODPS-0130261|	1	|Invalid schema|
|ODPS-0130271|	1	|Partition does not exist|
|ODPS-0140005|	5	|	Unknown exception from planner|
|ODPS-0140011|	1	|Illegal type cast|
|ODPS-0140021|	1	|Illegal implicit type cast|
|ODPS-0140031|	1	|Invalid column reference|
|ODPS-0140041|	1	|Invalid UDF reference|
|ODPS-0140051|	1	|Invalid function|
|ODPS-0140061|	1	|Invalid parameters|
|ODPS-0140071|	1	|	Unsupported operator|
|ODPS-0140081|	1	|Unsupported join type|
|ODPS-0140091|	1	|	Unsupported stage type|
|ODPS-0140105|	5	|Invalid multiple I/O|
|ODPS-0140133|	3	|Invalid structure|
|ODPS-0140151|	1	|Can not do topologic sort, the stages is not a DAG|
|ODPS-0140171|	1	|Sandbox violation exception|
|ODPS-0140181|	1	|Sql plan exception|

### ODPS Tunnel ERROR Code

Since now, the Tunnel has Different ERROR Code, Below is the List:

|Code	| Message|
|--|--|
|AccessDenied|	Access Denied|
|CorruptedDataStream	|The data stream was corrupted, please try again later	|
|DataUnderReplication	|The specified table data is under replication and you cannot initiate upload or download at this time. Please try again later|
|DataVersionConflict	|The specified table has been modified since the upload or download initiated and table data is being replicated at this time. Please initiate another download or upload later|
|FlowExceeded	|Your flow quota is exceeded	|
|InConsistentBlockList	|The specified block list is not consistent with the uploaded block list on server side	|
|IncompleteBody|	You did not provide the number of bytes specified by the Content-Length HTTP header	|
|InternalServerError	|Service internal error, please try again later|
|InvalidArgument	|Invalid argument	|
|InvalidBlockID	|The specified block id is not valid|
|InvalidColumnSpec	|The specified columns is not valid|
|InvalidRowRange	|The specified row range is not valid|	
|InvalidStatusChange|	You cannot change the specified upload or download status	|
|InvalidURI	|Couldn’t parse the specified URI	|
|InvalidUriSpec	|The specified uri spec is not valid|	
|MalformedDataStream	|The data stream you provided was not well-formed or did not validate against schema	|
|MalformedHeaderValue	|An HTTP header value was malformed|	
|MalformedXML	|The XML you provided was not well-formed or did not validate against schema	|
|MaxMessageLengthExceeded	|Your request was too big	|
|MethodNotAllowed	|The specified method is not allowed against this resource	|
|MissingContentLength	|You must provide the Content-Length HTTP header|	
|MissingPartitionSpec	|You need to specify a partitionspec along with the specified table	|
|MissingRequestBodyError	|The request body is missing|	
|MissingRequiredHeaderError	Your |request was missing a required header|	
|NoPermission	|You do not have enough privilege to complete the specified operation	|
|NoSuchData	|The uploaded data within this uploaded no longer exists|	
|NoSuchDownload	|The specified download id does not exist|	
|NoSuchPartition	|The specified partition does not exist|
|NoSuchProject	|The specified project name does not exist|	
|NoSuchTable	|The specified table name does not exist|	
|NoSuchUpload	|The specified upload id does not exist|	
|NoSuchVolume	|The specified volume name does not exist|	
|NoSuchVolumeFile	|The specified volume file does not exist|	
|NoSuchVolumePartition|	The specified volume partition does not exist|	
|NotImplemented	|A header you provided implies functionality that is not implemented	|
|ObjectModified	|The specified object has been modified since the specified timestamp	|
|RequestTimeOut	|Your socket connection to the server was not read from or written to within the timeout period	|
|ServiceUnavailable	|Service is temporarily unavailable, Please try again later	|
|StatusConflict	|You cannot complete the specified operation under the current upload or download status	|
|TableModified	|The specified table has been modified since the download initiated. Try initiate another download	|
|Unauthorized	|The request authorization header is invalid or missing|	
|UnexpectedContent	|This request does not support content|	