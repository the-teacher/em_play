require 'eventmachine'
require 'sinatra/base'
require 'thin'

def run(opts)
  # Start reactor
  EM.run do
    # define some defaults for our app
    server  = opts[:server] || 'thin'
    host    = opts[:host]   || '0.0.0.0'
    port    = opts[:port]   || '8181'
    web_app = opts[:app]

    dispatch = Rack::Builder.app do
      map '/' do
        run web_app
      end
    end

    unless %w[thin hatetepe goliath].include? server
      raise "Need an EM webserver, but #{server} isn't"
    end

    # Start the web server.
    # Note that you are free to run other tasks within your EM instance.
    Rack::Server.start({
      app:    dispatch,
      server: server,
      Host:   host,
      Port:   port
    })
  end
end

class EmServer < Sinatra::Base
  # threaded - False: Will take requests on the reactor thread
  #            True:  Will queue request for background thread
  configure do
    # set :threaded, false
    EM.threadpool_size = 5
  end

  # Request runs on the reactor thread (with threaded set to false)
  # and returns immediately. The deferred task does not delay the
  # response from the web-service.
  get '/' do
    operation = proc do
      print "Incoming Heavy Request => EM.size: #{EM.threadpool_size}"
      sleep 5
    end

    callback = proc do |res|
      puts 'Task is Finished'
    end

    EM.defer(operation, callback)
  end
end