require 'minitest/autorun'
require 'stripe'
require 'csv'
require 'fileutils'
require 'json'
require 'webmock'
require_relative '../../customers_to_csv'

include WebMock::API

WebMock.enable!

class AddTest < MiniTest::Test
  def test_api_status_success
    stub_request(:any, %r{api.stripe.com/v1/customers})
      .to_return(status: [200, 'Success'], body: File.read('./tests/mocks/customers_api_res.json'))

    api_res = get_stripe_customers({ limit: 2 })
    assert_equal 2, api_res['data'].length
  end

  def test_api_status_failure
    stub_request(:any, %r{api.stripe.com/v1/customers})
      .to_return(status: [500, 'Too Many Requests'], body: 'Error')

    assert_raises Stripe::APIError do
      get_stripe_customers({ limit: 2 })
    end
  end

  def test_customers_to_csv
    customers_file = '/tmp/stripe_customers_test.csv'

    CSV.open(customers_file, 'w') do |csv_writer|
      append_customers_to_csv(csv_writer, JSON.parse(File.read('./tests/mocks/customers_api_res.json')))
    end
    assert FileUtils.identical?(customers_file, './tests/mocks/stripe_customers.csv')
  end
end
