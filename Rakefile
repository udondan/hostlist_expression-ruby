# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "rubocop/rake_task"

# release-please creates tags without a "v" prefix. Match that, so the release
# task finds the existing tag instead of creating a "v"-prefixed duplicate.
Bundler::GemHelper.instance.define_singleton_method(:version_tag) { version.to_s }

RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new(:rubocop)

task default: %i[rubocop spec]
