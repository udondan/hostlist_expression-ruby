# frozen_string_literal: true

require "hostlist_expression"

RSpec.describe "#hostlist_expression" do
  it "plain host without range" do
    expect(hostlist_expression("host.com")).to eq(["host.com"])
  end

  it "numeric from 1 to 99" do
    expect(hostlist_expression("host-[1-99].com")).to eq((1..99).map { |n| "host-#{n}.com" })
  end

  it "numeric from 01 to 99" do
    expect(hostlist_expression("host-[01-99].com")).to eq((1..99).map { |n| "host-#{n.to_s.rjust(2, '0')}.com" })
  end

  it "numeric from 2 to 12" do
    expect(hostlist_expression("host-[2-12].com")).to eq((2..12).map { |n| "host-#{n}.com" })
  end

  it "numeric from 02 to 12" do
    expect(hostlist_expression("host-[02-12].com")).to eq((2..12).map { |n| "host-#{n.to_s.rjust(2, '0')}.com" })
  end

  it "numeric from 99 to 01" do
    expect(hostlist_expression("host-[99-01].com")).to eq((1..99).map { |n| "host-#{n.to_s.rjust(2, '0')}.com" })
  end

  it "numeric from 12 to 2" do
    expect(hostlist_expression("host-[12-2].com")).to eq((2..12).map { |n| "host-#{n}.com" })
  end

  it "numeric from 10 to 9" do
    expect(hostlist_expression("host-[10-9].com")).to contain_exactly("host-9.com", "host-10.com")
  end

  it "numeric from 1 to 010" do
    expect(hostlist_expression("host-[1-010].com")).to eq((1..10).map { |n| "host-#{n.to_s.rjust(3, '0')}.com" })
  end

  it "numeric sequence 10, 20, 30" do
    expect(hostlist_expression("host-[10,20,30].com")).to contain_exactly("host-10.com", "host-20.com", "host-30.com")
  end

  it "string from a to z" do
    expect(hostlist_expression("host-[a-z].com")).to eq(("a".."z").map { |c| "host-#{c}.com" })
  end

  it "string from A to Z" do
    expect(hostlist_expression("host-[A-Z].com")).to eq(("A".."Z").map { |c| "host-#{c}.com" })
  end

  it "string from Z to A" do
    expect(hostlist_expression("host-[Z-A].com")).to eq(("A".."Z").map { |c| "host-#{c}.com" })
  end

  it "alphabetic sequence A, D, Z" do
    expect(hostlist_expression("host-[A,D,Z].com")).to contain_exactly("host-A.com", "host-D.com", "host-Z.com")
  end

  it "mixed numeric and alphabetic, sequence and ranges" do
    expect(hostlist_expression("host-[f,G-H,42,09-11][A,B].com")).to contain_exactly(
      "host-09A.com", "host-09B.com", "host-10A.com", "host-10B.com", "host-11A.com", "host-11B.com",
      "host-42A.com", "host-42B.com", "host-GA.com", "host-GB.com", "host-HA.com", "host-HB.com",
      "host-fA.com", "host-fB.com"
    )
  end
end
