# README

## Setup
```
bundle exec rails db:create
bundle exec rails db:migrate
```

## Tests
```
bundle exec rspec
```

Unfortunately, the integration of endpoints for accounts and transactions had to be done blindly, without the ability to test it on a test environment.
Also, need to think about how to change the structure of the transaction table and remove the fields from the date column.
I apologize for the delay. After gaining access to the test environment, it turned out that the assumptions were incorrect.
