ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/autorun'
require 'minitest/reporters'

Minitest::Reporters.use!(  Minitest::Reporters::DefaultReporter.new,
                           ENV,
                           Minitest.backtrace_filter )
# reporter_options = { color: true }
# Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(reporter_options)]

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

class MiniTest::Spec
  include ActiveSupport::Testing::SetupAndTeardown
  include ActiveRecord::TestFixtures

  alias :method_name :name if defined? :name
  self.fixture_path = File.join(Rails.root, 'test', 'fixtures')

  fixtures :all
end