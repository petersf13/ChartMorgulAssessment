require 'minitest/autorun'
require_relative '../../fake_database'

class AddTest < MiniTest::Test
  DATABASE_NAME = '/tmp/fake_database'.freeze  # name to pass to our database class
  DATABASE_DIR = "#{DATABASE_NAME}.json".freeze  # local path to our database

  File.delete(DATABASE_DIR) if File.file?(DATABASE_DIR)

  DATABASE = FakeDatabase.new(DATABASE_NAME)

  def test_get_and_set
    assert_nil DATABASE.get(:last_id)

    DATABASE.set(:last_id, 'cus_KhaZn7EYPzetOe')

    mock_db = JSON.parse(File.read('./tests/mocks/fake_database.json'))
    test_db = JSON.parse(File.read(DATABASE_DIR))
    assert_equal mock_db, test_db

    assert_equal 'cus_KhaZn7EYPzetOe', DATABASE.get(:last_id)
  end
end
