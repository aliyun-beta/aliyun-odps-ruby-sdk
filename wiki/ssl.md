## SSL Connection

We support SSL connection in two ways:

1. just encrypt request but server not verify cert, just config with https endpoint, eg: https://service.odps.aliyun.com/api'

2. To enable server verify your request, config ssl_ca_file in addition, eg: config.ssl_ca_file = 'path/to/your/ssl/ca/file'
