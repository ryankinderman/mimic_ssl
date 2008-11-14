= mimic_ssl plugin
 
* http://github.com/ryankinderman/mimic_ssl
* http://kinderman.net
 
== DESCRIPTION:

This is a Ruby on Rails plugin that allows an application using the ssl_requirement[http://github.com/rails/ssl_requirement] plugin to behave as if there is an SSL server running when there isn't. It does this by patching the way that Rails determines if a particular request is an SSL request and, correspondingly, the way that it and the ssl_requirement plugin construct a URL that targets the SSL protocol.

This patch makes it possible to test the SSL-dependent behavior of the system without having to actually set up an SSL server. This is useful if you don't want to go through the hassle and configuration limitations of running a local SSL server or proxy, but still want a way to test the SSL-dependent behavior of your application in, for example, Selenium, or manually in development mode.

== INSTALL:
  
  % cd <rails_app_directory>
  % script/plugin install git://github.com/ryankinderman/mimic_ssl.git
  
== USAGE:

To load the patches and functionality provided by the plugin, you must set the MIMIC_SSL environment variable to "true", either on the command-line, or in the environment-loading logic of your application, mabye based on some conditions. So, for example, you can do:

  % MIMIC_SSL=true script/server

or, in environment.rb, maybe something like:

  ...
  mimic_ssl_environments = ['development', 'selenium']
  
  Rails::Initializer.run do |config|
    ...
    ENV['MIMIC_SSL'] = mimic_ssl_environments.include?(ENV['RAILS_ENV']).to_s
    ...
  end
  ...

This was done so that the overhead of mimicking SSL can be completely avoided in production environments. How you manage this switch is completely up to you.