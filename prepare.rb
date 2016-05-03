#!/usr/bin/env ruby
require 'fileutils'

if ARGV.size < 1
  STDERR.puts "usage: prepare.rb App.app [team-identifier] [bundle-id-prefix]"
  exit 1
end

app = ARGV[0]
new_team_identifier = ARGV[1] || "38F637AQG5"
bundle_id_prefix = ARGV[2] || "nz.net.bdash.Test.3P"

print "Extracting entitlements..."
FileUtils.remove_file "entitlements.plist", true
system("codesign", "-d", "--entitlements=:entitlements.plist", app, :err => :close) or exit 1
puts " Done!"

print "Extracting team and app identifiers..."
existing_team_identifier=`/usr/libexec/PlistBuddy -c "Print :com.apple.developer.team-identifier" entitlements.plist`.chomp
existing_app_identifier=`/usr/libexec/PlistBuddy -c "Print :application-identifier" entitlements.plist`.chomp
puts " Done!"

if existing_team_identifier == new_team_identifier
  STDERR.puts "#{app} already appears to belong to team #{new_team_identifier}!"
  exit 1
end

existing_bundle_identifier = existing_app_identifier.gsub("#{existing_team_identifier}.", "")
new_bundle_identifier = "#{bundle_id_prefix}.#{existing_bundle_identifier}"
new_app_identifier = existing_app_identifier.gsub(existing_team_identifier, "#{new_team_identifier}.#{bundle_id_prefix}")

system("plutil", "-convert", "xml1", "#{app}/Info.plist") or exit 1

print "Updating entitlements to reflect new team identifier..."
system("/usr/libexec/PlistBuddy", "-c", "Set :get-task-allow true", "-c", "Save", "entitlements.plist", :out => :close) or exit 1
system("sed", "-i", "", "-e", "s/#{existing_app_identifier}/#{new_app_identifier}/g", "-e", "s/#{existing_team_identifier}/#{new_team_identifier}/g", "entitlements.plist") or exit 1
puts " Done!"

print "Updating Info.plist to reflect new bundle identifier..."
system("sed", "-i", "", "-e", "s/>#{existing_bundle_identifier}</>#{new_bundle_identifier}</g", "#{app}/Info.plist") or exit 1
puts " Done!"
