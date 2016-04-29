#!/usr/bin/env ruby

if ARGV.size < 1
  STDERR.puts "usage: prepare.rb App.app [signing-identity]"
  exit 1
end

app = ARGV[0]
signing_identity = ARGV[1] || "iPhone Developer: Mark Rowe (RSYL4QFV9U)"

Dir.glob("#{app}/Frameworks/*.framework") do |framework|
    system("codesign", "-f", "-s", signing_identity, framework) or exit 1
end

system("codesign", "-f", "--entitlements=entitlements.plist", "-s", signing_identity, app) or exit 1
