## Get Started

First of all, config your environment.

If you use Rails, you can place it in `config/initializers/aliyun_odps.rb`, for other framework, just place it before your other odps code.

    Aliyun::Odps.configure do |config|
      config.access_key = '<your-access-key>'
      config.secret_key = '<your-secret-key>'
      config.endpoint = '<odps-server-api>'  # "http://service.odps.aliyun.com/api"
      config.project = '<your-default-project>'
    end

After that, you can get your project and start party now!

    project = Aliyun::Odps.project

    # Accesss tables
    project.tables.list

    # Access resources
    project.resources.list

    # Access instances
    project.instances.list

    # Access functions
    project.functions.list


    # For Tunnel
    project.table_tunnels

Next, Let's visit [Project](./projects.md)
