# frozen_string_literal: true

require "simplecov"
require "simplecov-cobertura"

SimpleCov.start do
  add_filter "/spec/"
  formatter SimpleCov::Formatter::MultiFormatter.new(
    [
      SimpleCov::Formatter::HTMLFormatter,
      SimpleCov::Formatter::CoberturaFormatter
    ]
  )
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.disable_monkey_patching!
  config.warnings = true
  config.order = :random
  Kernel.srand config.seed
end
