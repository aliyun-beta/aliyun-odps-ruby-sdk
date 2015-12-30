# Project

[Project](https://docs.aliyun.com/#/pub/odps/basic/definition&project) is the basic unit to keep your system organized, it's very similar to `database` or `schema` in traditional relational database.


## ```get```

We could call ```get``` to fetch a project information

```ruby
    project = client.projects.get('my_project_test') #fetch a project by name
    project = client.projects.get()                  #get the default project
```

If no project name was provide, it will return the default project which was configured by configuration

You could check existence of a project by `get` method as well, if the project doesn't exist, it will raise `Aliyun::Odps::RequestError: NoSuchObject: ODPS-0420111`


## ```list```
We could list all available projects by calling ```list```.

```ruby
    #list projects by options
    projects = client.projects.list(owner: 'owner', #specify the project owner
                                    marker: 'marker', #specify marker for paginate
                                    maxitems: '1') #specify maxitems in this request, default 1000
```

It will support three options `owner`, `marker` and `maxitem`, see the usage by example.

## ```update```

Right now you are only able to update a project comment by update method, passing by options

```ruby
    #list projects by options
    client.projects.update('my_project_test', comment: 'just a test')
```