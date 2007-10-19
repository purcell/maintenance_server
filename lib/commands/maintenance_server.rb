HTML_DIR = "#{RAILS_ROOT}/public"
MAINTENANCE_PAGE = "#{HTML_DIR}/maintenance.html"
BIND_INTERFACE = "127.0.0.1"
unless (PORT = ARGV.first)
  STDERR.write("usage: #{$0} port\n")
  exit 1
end

require 'rubygems'
require 'mongrel'

class MaintenanceHandler < Mongrel::HttpHandler
  def initialize(dir_handler)
    @dir_handler = dir_handler
  end

  def process(request, response)
    path = request.params['PATH_INFO']
    return @dir_handler.process(request, response) if @dir_handler.can_serve(path)
    response.start(503) do |head, out|
      head["Content-Type"] = "text/html"
      out.write(File.read(MAINTENANCE_PAGE))
    end
  end
end

h = Mongrel::HttpServer.new(BIND_INTERFACE, PORT)
h.register("/", MaintenanceHandler.new(Mongrel::DirHandler.new(HTML_DIR, false)))
h.run.join
