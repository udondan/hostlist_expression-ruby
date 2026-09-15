# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = "hostlist_expression"
  s.version     = "0.2.1"
  s.summary     = "Expand hostlist expression"
  s.description = <<~DESCRIPTION
    Expand hostlist expression like those defined in pdsh or Ansible inventory files.

    An expression like "host-[1-3].com" will expand into an array containing the elements host-1.com, host-2.com and host-3.com

    See https://github.com/udondan/hostlist_expression-ruby for documentation
  DESCRIPTION
  s.authors     = ["Daniel Schroeder"]
  s.email       = "daniel@phatthanan.com"
  s.files       = ["lib/hostlist_expression.rb"]
  s.homepage    = "https://github.com/udondan/hostlist_expression-ruby"
  s.license     = "MIT"

  s.required_ruby_version = ">= 3.3"

  s.metadata = {
    "source_code_uri" => "https://github.com/udondan/hostlist_expression-ruby",
    "rubygems_mfa_required" => "true"
  }
end
