## Project

[Project](https://docs.aliyun.com/#/pub/odps/basic/definition&project) is the basic unit to keep your system organized, it's very similar to `database` or `schema` in traditional relational database.

Besides the way to get your project you already hear in Readme, here we list some more feature to access your projects.


### LIST

We could list all available projects by calling `Aliyun::Odps.list_projects`.


    #list projects by options
    projects = Aliyun::Odps.list_projects(
                 owner: 'owner', #specify the project owner
                 marker: 'marker', #specify marker for paginate
                 maxitems: '1'
               ) #specify maxitems in this request, default 1000


It will support three options `owner`, `marker` and `maxitem`, see the usage by example.

Besides, it has a alias `Aliyun::Odps.projects`, choose your favorite style!!


### GET

As you known, Aliyun::Odps.project can get your default project, but if you pass a name, you can get other project quickly.

We could call `Aliyun::Odps.project` to fetch a project information


    project = Aliyun::Odps.project                     #get the default project
    project = Aliyun::Odps.project('my_other_project') #fetch a project by name

If no project name was provide, it will return the default project which was configured by `Aliyun::Odps.configure`

If you pass a noexist project name, it will raise `Aliyun::Odps::RequestError: NoSuchObject: ODPS-0420111`.

By the way, in our library, all request to odps fail, will raise `Aliyun::Odps::RequestError`. For more detail, visit [Error](./error.md)


## UPDATE

Right now you are only able to update a project comment by update method, passing by options


    #update project by options
    Aliyun::Odps.update_project('my_project_name', comment: 'just for test')
    
Now, let's go to [Tables](./tables.md)    