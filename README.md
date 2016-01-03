# Aliyun ODPS SDK

-----

It is a full-featured Ruby Library for Aliyun ODPS API. Enjoy it!

## Installation

It's a Ruby Gem, so you can install it like any Gem:

    gem install aliyun-odps

If you use Gemfile manage your Gems, Add below to your Gemfile.

    gem "aliyun-odps", require: 'aliyun/odps'

And run:

    bundle install


## Usage

### Quick Start

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

More Example and Scenario, visit our [Document](#document)


## Document

Here is original Restful API, It has the most detailed and authoritative explanation for every API.

+ [http://repo.aliyun.com/api-doc/index.html](http://repo.aliyun.com/api-doc/index.html)

Here is our RDoc Document, It's well format to help you find more detail about methods.

+ [RDoc Document](http://www.rubydoc.info/gems/aliyun-odps/0.1.0)


Here are some more guides for help you. Welcome to advice.

+ [Installation](./wiki/installation.md)
+ [Getting Started](./wiki/get_start.md)
+ [Projects](./wiki/projects.md)
+ [Instances](./wiki/instances.md)
+ [Resources](./wiki/resources.md)
+ [Functions](./wiki/functions.md)
+ [Tables](./wiki/tables.md)
+ [Tunnels](./wiki/tunnels.md)
+ [Error Code](./wiki/error.md)


## Test

We use minitest for test and rubocop for Syntax checker, If you want to make contribute to this library. Confirm below Command is success:

    bundle exec rake test


## Authors && Contributors

- [Newell](https://github.com/zlx_star)
- [genewoo](https://github.com/genewoo)


## License

licensed under the [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0.html)
