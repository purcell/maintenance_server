#!/usr/bin/env ruby

require "#{File.dirname($0)}/../../../config/boot" unless defined?(RAILS_ROOT)

for f in ["#{RAILS_ROOT}/script/maintenance_server", "#{RAILS_ROOT}/public/maintenance.html"]
  puts "Removing #{f}"
  File.unlink(f) if File.exist?(f)
end
