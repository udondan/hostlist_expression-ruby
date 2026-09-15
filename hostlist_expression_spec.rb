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
  it 'numeric from 2 to 12' do
    hosts = Array.new
    hosts = hostlist_expression("host-[2-12].com")
    expect(hosts.instance_of?(Array)).to be_truthy
    2.upto(12){|n|
      expect(hosts["#{n - 2}".to_i]).to eq "host-#{n}.com"
    }
  end
  it 'numeric from 02 to 12' do
    hosts = Array.new
    hosts = hostlist_expression("host-[02-12].com")
    expect(hosts.instance_of?(Array)).to be_truthy
    2.upto(12){|n|
      leading_zero = n.to_s.rjust(2, '0')
      expect(hosts["#{n - 2}".to_i]).to eq "host-#{leading_zero}.com"
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
  it 'numeric sequence 10, 20, 30' do
    hosts = Array.new
    hosts = hostlist_expression("host-[10,20,30].com")
    expect(hosts.instance_of?(Array)).to be_truthy
    expect(["host-10.com", "host-20.com", "host-30.com"]).to match_array(hosts)
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
  it 'alphabetic sequence A, D, Z' do
    hosts = Array.new
    hosts = hostlist_expression("host-[A,D,Z].com")
    expect(hosts.instance_of?(Array)).to be_truthy
    expect(["host-A.com", "host-D.com", "host-Z.com"]).to match_array(hosts)
  end
  
  it 'mixed numeric and alphabetic, sequence and ranges' do
    hosts = Array.new
    hosts = hostlist_expression("host-[f,G-H,42,09-11][A,B].com")
    expect(hosts.instance_of?(Array)).to be_truthy
    expect(["host-09A.com", "host-09B.com", "host-10A.com", "host-10B.com", "host-11A.com", "host-11B.com", "host-42A.com", "host-42B.com", "host-GA.com", "host-GB.com", "host-HA.com", "host-HB.com", "host-fA.com", "host-fB.com"]).to match_array(hosts)
  end
  
end
