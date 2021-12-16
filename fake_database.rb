require 'json'

# This class gets and sets values in a local JSON file
#
# name - String with name of the JSON file to store data in
# db - The Hash of the JSON file
class FakeDatabase
  def initialize(name)
    @@name = "#{name}.json"
    @@db = JSON.parse(File.read(@@name), { symbolize_names: true })
  rescue JSON::ParserError, Errno::ENOENT
    @@db = {
      last_id: nil
    }
  end

  def get(field)
    @@db[field]
  end

  def set(field, value)
    @@db[field] = value

    File.open(@@name, 'w') do |f|
      f.write(JSON.pretty_generate(@@db))
    end
  end
end
