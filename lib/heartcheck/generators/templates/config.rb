Heartcheck.setup do |monitor|
  # monitor has a default logger but you can use yours
  # default value: Logger.new(STDOUT)
  # monitor.logger = Rails.logger

  # Using threaded executor
  #
  # With this feature is possible to parallelize io-bound checkers
  # using ruby threads, but to enable this feature you need explicitly
  # install 'concurrent-ruby' gem on your project
  # monitor.use_threaded_executor!

  # Checks
  # For each check you can set the folling options
  #        name: String  => root name to show in report page (default: class.name)
  #  functional: Boolean => When is false your check is essential to your application (default: false)
  #     doc_url: String  => To provide more details about the failure (optional)
  # (default: nil)
  #   cache_expires_in: Integer => If provided (in seconds), cache the result
  # of the check for a time
  #    on_error: Block   => to customize the errors (default: nil)
  # to_validate: Block   => to validate the sevices (default: nil)
  #
  # See the exemple bellow to undertand how you can configure it.
  #
  # monitor.add :base do |c|
  #   c.name       = "filesystem"
  #   c.functional = true
  #   c.add_service(name: "my_file", path: "/var/www/my_project/my_file")
  #   c.doc_url    = 'http://docs.com/monitoring#check-filesystem'
  #   c.cache_expires_in  = 10.minutes # default nil
  #
  #   c.on_error do |sevices|
  #     errors << "Custom error message for #{service[:name]}"
  #   end
  #
  #   c.to_validate do |services, errors|
  #     services.each do |service|
  #       errors << "erro message" unless if File.exists?(service[:path])
  #     end
  #   end
  # end
  #
  # Services
  # All check can receive a service to check.
  # For example you can add 2 diferent hosts to check the firewall in the same checker.
  #
  # monitor.add :firewall do |c|
  #   c.add_service(host: 'lala.com', port: 80)
  #   c.add_service(host: 'popo.com', port: 80)
  # end
  #
  # Take atention because we evaluate the services when ruby load the configuration file.
  # But there's a way to send a service that will evaluate when the test will run. To use with thats way
  # you need to register a service with `register_dynamic_services`.
  # http://www.rubydoc.info/github/locaweb/heartcheck/Heartcheck/Checks/Base#register_dynamic_services-instance_method
  #
  # monitor.add :firewall do |c|
  #   c.register_dynamic_services do
  #     [
  #       { host: 'lala.com', port: 80 },
  #       { host: 'popo.com', port: 80 }
  #     ]
  #   end
  # end


  # Firewall
  # check with telnet if the firewall is open to conect to the service
  monitor.add :firewall do |c|
    # you can add service wth (host and port) or (url)
    c.add_service(host: 'lala.com', port: 80)
    c.add_service(url: 'http://lalal.com')

    # add dynamic services when you need it run after initializer
    c.register_dynamic_services do
      Pmta.all.map { |p| { host: p.host, port: 25 } }
    end

    # to customize default error message, the default is:
    # "connection refused on: #{service.host}:#{service.port}"
    # params
    # errors:  Array           => errors to show on page
    # service: FirewallService => object that respond to :host and :port
    c.on_error do |errors, service|
      errors << "Custom error message for #{service.host}"
    end
  end

  # Redis
  # check if you redis conection is working
  # you need to send a redis conection as a service
  monitor.add :redis do |c|
    c.add_service(name: 'Redis', connection: Resque.redis)
  end

  # Cache
  # check if your cache is working
  # you can pass any kind of cache, but this need to respond to
  # set, get and delete
  monitor.add :cache do |c|
    c.add_service(name: 'memcached', connection: Rails.cache.instance_variable_get('@data'))
  end

  # WatchFile
  # check if a preloaded file as changed from the disk
  monitor.add :watch_file do |c|
    c.add_service(file: 'version.json')
  end
end
