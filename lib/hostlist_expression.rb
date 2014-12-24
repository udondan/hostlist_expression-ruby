# Author: Daniel Schroeder
# License: MIT
# Home: https://github.com/udondan/hostlist_expression-ruby

# Public: Expand hostlist expression
#
# expression  - Hostlist expression.
# separator - Character(s) for separating ranges (default: [":", "-"]).
#
# Examples
#
#   hostlist_expression("your-host-[1-3].com")
#   # => ["your-host-1.com", "your-host-2.com", "your-host-3.com"]
#
# Returns the expanded host list as array.
def hostlist_expression(expression, separator = [":", "-"])
  
  # Validate range separator
  if separator.class == Array
    separator = separator.join("")
  end
  if not separator.class == String
    raise "Error: Range separator must be either of type String or Array. given: #{separator.class}"
  elsif separator.length == 0
    raise "Error: Range separator is empty"
  end
  
  # Prepeare separator for use in regular expressions
  separator = Regexp.escape(separator)
  
  # Return input, if this is not a hostlist expression
  return expression if not expression.match(/\[(?:[\da-z]+(?:[#{separator}][\da-z]+)?,?)+\]/i)
  
  # hosts array will hold all expanded results, it as well is the working array where partially resolved results are stored
  hosts = Array.new
  hosts.push(expression)
  
  # Iterate over all range definitions, e.g. [0:10] or [A:Z]
  expression.scan(/\[([\da-z#{separator},]+)\]/i).each do|match|
    
    # Will hold replacements for each match
    replacements = Array.new
    
    # The pattern may be a sequence with multiple ranges. Split...
    match[0].split(",").each do |range|
      
      # Split ranges by range separator
      range_items = range.split(/[#{separator}]/)
      
      # If it's not really a range, duplicate the single item
      if range_items.length == 1
        range_items.push(range_items[0])
      end
      
      # Numeric range
      if range_items[0].match(/^[0-9]+$/) and range_items[1].match(/^[0-9]+$/)
        isnum = true
        from = range_items[0].to_i
        to = range_items[1].to_i
      
      # Uppercase alphabetic range
      elsif range_items[0].length == 1 and range_items[1].length == 1 and /^[[:upper:]]+$/.match(range_items[0]) and /^[[:upper:]]+$/.match(range_items[1])
        alphabet = ('A'..'Z').to_a
        from = alphabet.index(range_items[0])
        to = alphabet.index(range_items[1])
      
      # Lowercase alphabetic range
      elsif range_items[0].length == 1 and range_items[1].length == 1 and /^[[:lower:]]+$/.match(range_items[0]) and /^[[:lower:]]+$/.match(range_items[1])
        alphabet = ('a'..'z').to_a
        from = alphabet.index(range_items[0])
        to = alphabet.index(range_items[1])
      
      else
      end
      
      # Fail if "to" is higher than "from"
      if from>to
        puts "Error: Invalid host range definition. 'to' part must be higher than 'from' part: #{expression}"
        exit 1
        raise "Error: Invalid host range definition #{expression}"
      end
      
      # Iterate over all hosts and store the resolved patterns in "replacements"
      hosts.each do |exitem|
        
        # Iterate over the range
        (from..to).each do |i|
          if isnum
            # Formatting number with leading zeros
            replacements.push("#{i}".rjust(range_items[0].length, "0"))
          else
            # Select correct letter from alphabet
            replacements.push(alphabet[i])
          end
        end
      end
    end
    
    # We clone the hosts array, because we can't modify it while iterating over its elements. So we iterate over the clone instead
    hosts.clone.each do |exitem|
      
      # Remove the original element
      hosts.delete(exitem)
      
      # Iterate over previously stored replacements
      replacements.each do|replacement|
        # Adding replacement to hosts array
        hosts.push(exitem.sub(/\[#{match[0]}\]/, replacement))
      end
    end
  end
  
  return hosts.uniq
end
