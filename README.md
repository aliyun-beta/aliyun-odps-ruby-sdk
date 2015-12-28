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

First of all, config your environment, if you use Rails, you will be familiar with below configuraion, you can place it under `config/initializers`, for other framework, just place it before your use code.

    Aliyun::Odps.configure do |config|
      config.access_key = '<your-access-key>'
      config.secret_key = '<your-secret-key>'
      config.endpoint = '<odps-server-api>'  # "http://service.odps.aliyun.com/api"
      config.project = '<your-default-project>'
    end

After that, you can get your project with below code and start party now!

    project = Aliyun::Odps.project

    # list tables
    project.tables.list

    # list resources
    project.resources.list

    # list instances
    project.instances.list

    # list functions
    project.functions.list


    # For Tunnel
    project.table_tunnels

More Example and Scenario, visit our [Document](#document)

## Document

Here is original Restful API, It has the most detailed and authoritative explanation for every API.

+ [http://repo.aliyun.com/api-doc/index.html](http://repo.aliyun.com/api-doc/index.html)

Here is thr RDoc Document for this Library, use to find mostly usage for methods.

+ [RDoc Document]()


Here are some more guides for help you. Welcome to advice.

+ [Installation](./wiki/installation.md)
+ [Getting Started](./wiki/get_start.md)
+ [Error Code](./wiki/error.md)


## Test

We use minitest for test and rubocop for Syntax checker, If you want to make contribute to this library. Confirm below Command is success:

    bundle exec rake test


## Authors && Contributors

- [Newell Zhu](https://github.com/zlx_star)


## License

licensed under the [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0.html)
