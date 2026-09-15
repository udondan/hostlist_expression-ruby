# hostlist_expression

[![Gem Version](https://badge.fury.io/rb/hostlist_expression.svg)](https://badge.fury.io/rb/hostlist_expression)

Ruby [gem](https://rubygems.org/gems/hostlist_expression) for expanding hostlist expressions.

An expression like `host-[1-3].com` will expand into an array containing these elements:

```text
host-1.com
host-2.com
host-3.com
```

This gem supports **numeric** and **alphabetic** **ranges** and **sequences**, and any combination.

By default both characters `:` ([Ansible](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html) style) and `-` ([pdsh](https://github.com/chaos/pdsh) style) are interpreted as range connectors.

Numeric ranges can have leading zeros `[01-99]`. If either bound has a leading zero, all numbers are padded to the width of the longest bound, so `[1-010]` expands to `001` through `010`.

With commas you can define sequences: `[1,3,5]`.

Ranges may be written in either direction, `[9-1]` expands the same as `[1-9]`. Duplicate hosts are removed from the result.

A complex example with all variations:

Expression: `host-[A-C]-[c,d,001-003].com`

Result:

```text
host-A-c.com
host-A-d.com
host-A-001.com
host-A-002.com
host-A-003.com
host-B-c.com
host-B-d.com
host-B-001.com
host-B-002.com
host-B-003.com
host-C-c.com
host-C-d.com
host-C-001.com
host-C-002.com
host-C-003.com
```

Please note, in an alphabetic range both items are required to be either lowercase or uppercase, you can't mix. A range like `[A-c]` will raise a `RuntimeError`.

## Installation

Requires Ruby 3.3 or newer.

```sh
gem install hostlist_expression
```

Or add it to your `Gemfile`:

```rb
gem "hostlist_expression"
```

## Usage

```rb
require "hostlist_expression"
hosts = hostlist_expression("host-[1-3].com")
p hosts

# => ["host-1.com", "host-2.com", "host-3.com"]
```

The result is always an Array. Input without any range is returned as a single-element Array:

```rb
hostlist_expression("host.com")

# => ["host.com"]
```

You may optionally pass custom range connectors as the second argument, either a String or an Array of characters:

```rb
hosts = hostlist_expression("host-[1~3].com", "~")
hosts = hostlist_expression("host-[1~3,A-C,x/z].com", ["~", "-", "/"])
```

## Development

```sh
bundle install
bundle exec rake    # runs RuboCop and the RSpec suite
```

## License

[MIT](LICENSE)
