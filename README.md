hostlist_expression
===================

Ruby [gem](https://rubygems.org/gems/hostlist_expression) for expanding hostlist expression.

An expression like `your-host-[1-3].com` will expand into an array containing the elements:
```
your-host-1.com
your-host-2.com
your-host-3.com
```

This gem supports **numeric** and **alphabetic** **ranges** and **sequences**, and any combination.

By default both `:` ([Ansible](http://docs.ansible.com/intro_inventory.html#hosts-and-groups) style) and `-` ([pdsh](https://code.google.com/p/pdsh/) style) are interpreted as dividers for sequences.

Numeric ranges can have leading zeros `[01-99]`.

A complex example with all variations:

Expression: `your-host-[A-C]-[c,d,001-003].com`

Result:
```
your-host-A-c.com
your-host-A-d.com
your-host-A-001.com
your-host-A-002.com
your-host-A-003.com
your-host-B-c.com
your-host-B-d.com
your-host-B-001.com
your-host-B-002.com
your-host-B-003.com
your-host-C-c.com
your-host-C-d.com
your-host-C-001.com
your-host-C-002.com
your-host-C-003.com
```

Please note, the left item of a range has to be lower than the right item. A range like `[20-10]` or `[Z-A]` will fail. Also, in an alphabetic range both items are required to be either lowercase or uppercase, you can't mix. A range like `[A-c]` will fail.

#Usage:
```rb
require "hostlist_expression"
hosts = hostlist_expression("your-host-[1-3].com")
print hosts

# => ["your-host-1.com", "your-host-2.com", "your-host-3.com"]
```

You may optionally pass custom characters for range definitions as 2nd parameter. (String or Array)

```rb
hosts = hostlist_expression("your-host-[1~3].com", "~")
hosts = hostlist_expression("your-host-[1~3,A-C,x/z].com", ["~", "-", "/"])
```

#License
MIT
