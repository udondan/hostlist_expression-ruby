# coding: utf-8
require "hostlist_expression"

describe "separator - " do
  it 'numeric from 1 to 99' do
    hosts = Array.new
    hosts = hostlist_expression("host-[1-99].com")
    expect(hosts.instance_of?(Array)).to be_truthy
    1.upto(99){|n|
      expect(hosts["#{n - 1}".to_i]).to eq "host-#{n}.com"
    }
  end
  it 'numeric from 01 to 99' do
    hosts = Array.new
    hosts = hostlist_expression("host-[01-99].com")
    expect(hosts.instance_of?(Array)).to be_truthy
    1.upto(99){|n|
      leading_zero = n.to_s.rjust(2, '0')
      expect(hosts["#{n - 1}".to_i]).to eq "host-#{leading_zero}.com"
    }
  end
  it 'numeric from 99 to 01' do
    hosts = Array.new
    hosts = hostlist_expression("host-[99-01].com")
    expect(hosts.instance_of?(Array)).to be_truthy
    1.upto(99){|n|
      leading_zero = n.to_s.rjust(2, '0')
      expect(hosts["#{n - 1}".to_i]).to eq "host-#{leading_zero}.com"
    }
  end
  
  it 'string from a to z' do
    hosts = Array.new
    alphabet = [*'a'..'z'] # Array splat
    hosts = hostlist_expression("host-[a-z].com")
    alphabet.each_with_index {|word, i|
      expect(hosts[i]).to eq "host-#{word}.com"
    }
  end
  it 'string from A to Z' do
    hosts = Array.new
    alphabet = [*'A'..'Z'] # Array splat
    hosts = hostlist_expression("host-[A-Z].com")
    alphabet.each_with_index {|word, i|
      expect(hosts[i]).to eq "host-#{word}.com"
    }
  end
  it 'string from Z to A' do
    hosts = Array.new
    alphabet = [*'A'..'Z'] # Array splat
    hosts = hostlist_expression("host-[Z-A].com")
    alphabet.each_with_index {|word, i|
      expect(hosts[i]).to eq "host-#{word}.com"
    }
  end
  
end
