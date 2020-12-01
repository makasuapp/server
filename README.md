# First time setup

1. Install rbenv
2. Install ruby: `rbenv install $(cat .ruby-version)`
3. Install bundler: `gem install bundler`
4. Install the repo's gems. First time will take a while: `bundle`
5. Create the database (you might have to install postgres manually first if there's issues): `rake db:create`
6. Populate the database: `rake db:migrate && rake db:seed`

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

# Testing

Run the type checker:
```
  srb tc
```

Run the automated tests:
```
  rails test
```
