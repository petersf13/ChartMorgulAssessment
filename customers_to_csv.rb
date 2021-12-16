# This is a script which gets customers from Stripe and writes them to a CSV
# We are, here, aware of a /v1/customers property in which, according to Stripe's docs,
# 'customers are returned sorted by creation date, with the most recent customers appearing first.'

require 'stripe'
require 'csv'
require './fake_database'

DATABASE = FakeDatabase.new('./fake_database')
FINAL_CUSTOMER_FLAG = '-1'.freeze # will be used to tell us we reached the last customer to get

Stripe.api_key = 'sk_test_RsUIbMyxLQszELZQEXHTeFA9008YRV7Vhr'

def get_stripe_customers(api_params)
  max_retries = 5
  retries = 1
  begin
    Stripe::Customer.list(api_params)
  rescue Stripe::RateLimitError
    raise Stripe::RateLimitError, "Max retries (#{max_retries}) exceeded." unless retries < max_retries

    sleep 2 * retries
    retries += 1
    retry
  end
end

def append_customers_to_csv(csv_writer, customers)
  customers['data'].each do |c|
    csv_writer << [c['id'], c['object'], c['email'], c['created']]
  end
  csv_writer.flush
end

if __FILE__ == $PROGRAM_NAME
  CSV.open('stripe_customers.csv', 'a+') do |csv_writer|
    last_id = DATABASE.get(:last_id) # the ID of the last customer downloaded

    break unless last_id != FINAL_CUSTOMER_FLAG

    loop do
      api_params = { limit: 50 }
      api_params[:starting_after] = last_id unless last_id.nil?

      puts "Getting /v1/customers with params #{api_params}"

      customers = get_stripe_customers(api_params)

      append_customers_to_csv(csv_writer, customers)

      last_id = customers['data'][-1]['id']  # Save the last user's ID
      DATABASE.set(:last_id, last_id)

      break unless customers['has_more']
    end
  end
  DATABASE.set(:last_id, FINAL_CUSTOMER_FLAG)
  puts 'All customers downloaded'
end
