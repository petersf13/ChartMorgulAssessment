require "rake/testtask"

Rake::TestTask.new do |t|
  t.test_files = FileList['tests/unit/*_test.rb']
end

Rake::TestTask.new do |t|
  t.test_files = FileList['tests/integration/integration_test.rb']
end
