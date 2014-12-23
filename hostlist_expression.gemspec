Gem::Specification.new do |s|
  s.name        = "hostlist_expression"
  s.version     = "0.1.0"
  s.date        = "2014-12-23"
  s.summary     = "Expand hostlist expression"
  s.description = <<-EOF
Expand hostlist expression like those defined in pdsh or Ansible inventory files.
  
An expression like "your-host-[1-3].com" will expand into an array containing the elements:
 - your-host-1.com
 - your-host-2.com
 - your-host-3.com

See https://github.com/udondan/hostlist_expression-ruby for documentation
EOF
  s.authors     = ["Daniel Schroeder"]
  s.email       = "daniel@phatthanan.com"
  s.files       = ["lib/hostlist_expression.rb"]
  s.homepage    = "https://github.com/udondan/hostlist_expression-ruby"
  s.license     = "MIT"
end
