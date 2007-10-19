#!/usr/bin/env ruby

require "#{File.dirname($0)}/../../../config/boot" unless defined?(RAILS_ROOT)

def create_file(path, &block)
  puts "Creating #{path}"
  if File.exist?(path)
    puts " - skipping: already exists"
  else
    File.open(path, 'w', &block)
    puts " - done"
  end
end

create_file("#{RAILS_ROOT}/script/maintenance_server") do |f|
  f.write(<<-'end_script')
#!/usr/bin/env ruby
# Avoid booting the full Rails environment...
RAILS_ROOT = "#{File.dirname(__FILE__)}/.."
require "#{RAILS_ROOT}/vendor/plugins/maintenance_server/lib/commands/maintenance_server"
  end_script
  File.chmod(0755, f.path)
end

create_file("#{RAILS_ROOT}/public/maintenance.html") do |f|
  f.write(<<-end_html)
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
  <title>Site temporarily unavailable</title>
  <style type="text/css">
    #message {
     background: white url(/images/logo.png) no-repeat top left;
     font-size: 120%;
     padding-top: 70px;
     width: 700px;
     margin: 50px;
    }
  </style>
</head>
<body>
<div id="message">
<h1>We'll be right back!</h1>
<p>
The site is temporarily unavailable while we make some improvements.
</p>
<p>
This usually takes only a few moments, so please bear with us and try again soon.
</p>
<p>
Best wishes from the team!
</div>
</body>
</html>
end_html
end
