# Database Diagram

You can find Workbench models file in shared IndexMedia folder on Dropbox. You need to install [MySQL Workbench](http://dev.mysql.com/downloads/workbench) to open it.

# Installation

##Clone repository

```
git clone git@bitbucket.org:yoose/dashboard
```

##Install Gems

```
cd dashboard
bundle install
```

##Create and Migrate Database for Development

```
rake db:create
rake db:migrate
```

# Start Development Server

```
rails s
```

