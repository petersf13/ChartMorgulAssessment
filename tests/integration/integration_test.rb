require 'minitest/autorun'
require 'webmock'
require 'csv'
require_relative '../../customers_to_csv'
require_relative '../../fake_database'

include WebMock::API

WebMock.enable!

class AddTest < MiniTest::Test
  DATABASE_NAME = '/tmp/fake_database'.freeze # name to pass to our database class
  DATABASE_DIR = "#{DATABASE_NAME}.json".freeze # local path to our database
  CUSTOMERS_CSV_DIR = '/tmp/stripe_customers_test.csv'.freeze

  File.delete(DATABASE_DIR) if File.file?(DATABASE_DIR)

  DATABASE = FakeDatabase.new(DATABASE_NAME)

  stub_request(:any, %r{api.stripe.com/v1/customers})
    .to_return(status: [200, 'Success'], body: File.read('./tests/mocks/customers_api_res.json'))

  def test_full_program
    last_id = DATABASE.get(:last_id)

    CSV.open(CUSTOMERS_CSV_DIR, 'w') do |csv_writer|
      customers = get_stripe_customers({ limit: 2 })
      append_customers_to_csv(csv_writer, customers)

      last_id = customers['data'][-1]['id']
      DATABASE.set(:last_id, last_id)
    end

    assert_equal 'cus_KhaZn7EYPzetOe', DATABASE.get(:last_id)
    assert_equal JSON.parse(File.read('./tests/mocks/fake_database.json')), JSON.parse(File.read(DATABASE_DIR))
    assert FileUtils.identical?(CUSTOMERS_CSV_DIR, './tests/mocks/stripe_customers.csv')
  end
end
