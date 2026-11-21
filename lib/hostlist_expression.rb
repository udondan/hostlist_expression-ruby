# frozen_string_literal: true

# Author: Daniel Schroeder
# License: MIT
# Home: https://github.com/udondan/hostlist_expression-ruby

# Expansion logic behind {#hostlist_expression}.
module HostlistExpression
  class << self
    # Expand hostlist expression. See {#hostlist_expression}.
    def expand(expression, separator = [":", "-"])
      separator = separator_pattern(separator)

      # Return input as single host, if this is not a hostlist expression
      return [expression] unless expression.match?(/\[(?:[\da-z]+(?:[#{separator}][\da-z]+)?,?)+\]/i)

      # Replace each bracket group, e.g. [0:10] or [A,C-E], in every partial host
      expression.scan(/\[([\da-z#{separator},]+)\]/i).reduce([expression]) do |hosts, (group)|
        replacements = group.split(",").flat_map { |range| expand_range(range, separator, expression) }
        hosts.flat_map { |host| replacements.map { |replacement| host.sub("[#{group}]", replacement) } }
      end.uniq
    end

    private

    # Validate the separator and escape it for use in a regexp character class
    def separator_pattern(separator)
      separator = separator.join if separator.is_a?(Array)
      unless separator.is_a?(String)
        raise "Error: Range separator must be either of type String or Array. given: #{separator.class}"
      end
      raise "Error: Range separator is empty" if separator.empty?

      Regexp.escape(separator)
    end

    # Expand a single sequence item, e.g. "1-3" or "A", into its values
    def expand_range(range, separator, expression)
      items = range.split(/[#{separator}]/)

      # If it's not really a range, duplicate the single item
      items.push(items[0]) if items.length == 1

      if items.all?(/\A[0-9]+\z/)
        numeric_range(items)
      elsif items.all?(/\A[A-Z]\z/) || items.all?(/\A[a-z]\z/)
        from, to = items.sort
        (from..to).to_a
      else
        raise "Error: Invalid host range definition #{expression}"
      end
    end

    # Pad numbers only if a bound has leading zeros, to the width of the longest bound
    def numeric_range(items)
      from, to = items.map(&:to_i).sort
      padding = items.any?(/\A0[0-9]/) ? items.map(&:length).max : 0
      (from..to).map { |i| i.to_s.rjust(padding, "0") }
    end
  end
end

# Expand hostlist expression
#
# @param [ String ] expression A host list expression.
# @param [ String, Array<String> ] separator - Character(s) for separating ranges.
#
# @example
#   hostlist_expression("your-host-[1-3].com")
#   # => ["your-host-1.com", "your-host-2.com", "your-host-3.com"]
#
# @return [ Array<String> ] A list of expanded hosts.
#
# @raise [ RuntimeError ] If the separator or a range definition is invalid.
#
# @since 0.1.0
def hostlist_expression(expression, separator = [":", "-"])
  HostlistExpression.expand(expression, separator)
end
