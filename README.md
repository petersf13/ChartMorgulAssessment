# ChartMogul's Assessment
In this assessment, all customers from Stripe had to be fetched from their API and written to a CSV file.

## Execution
To install all the dependencies, in the root folder run the command
```bundle install```.

To run the main program, in the root folder run the command
```ruby customers_to_csv.rb```.

The CSV with the customers will be stored in the root folder, under the name _stripe_customers.csv_.\
The database file will also be in the root folder, named _fake_database.json_.


To run all unit and integration tests, in the root folder use the command ```rake test```.

To run unit and integration tests individually, use the commands:
* ```ruby tests/unit/customers_to_csv_test.rb```
* ```ruby tests/unit/fake_database_test.rb```
* ```ruby tests/integration/integration_test.rb```

## Scripts
### _customers_to_csv.rb_
This is the main script. This file has the necessary functions and logic for calling Stripe's _customers_ endpoint and writing the results to a CSV.

### _fake_database.rb_
This file contains a custom, very basic, database simulation which will be used to save the last customer ID that was downloaded from Stripe.
Initially, I though about using SQLite for this. Maybe I should have, but I thought it was interesting to do it like this, in this use case.

## /tests
We have two folders, _unit_ and _integration_ which, as the names indicate, will have, respectively, the unit and integration tests, plus the necessary mock in _mocks_ folder.
