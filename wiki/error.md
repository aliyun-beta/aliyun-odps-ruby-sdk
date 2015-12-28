## Error Code


In our library, [RequestError]() is raised when a request fail, where you can get ODPS Error CODE, Message and request_id.

### ODPS Error

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