Ruby on Rails web server for interacting with the mobile apps

# First time setup

1. [Install ruby version manager](https://rvm.io/rvm/install)
2. Install ruby: `rvm install ruby-2.5.3`
3. Use the version installed: `rvm use ruby-2.5.3`
4. Install bundler: `gem install bundler`
5. Install gems. First time will take a while since it's installing Rails: `bundle`
6. Create the database (you might have to install postgres manually if there's issues): `rake db:create && rake db:migrate`

# Update server

Run these every time you pull in new commits:

```
  bundle
  rake db:migrate
  bundle exec rake rails_rbi:all
```

# Start the server

```
  rails s
```

# Test

Run the type checker:
```
  srb tc
```

Run the automated tests:
```
  rails test
```