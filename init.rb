require 'try_require'
try_require \
  'ssl_requirement',
  'SSL_REQUIREMENT_PATH',
  File.expand_path("#{File.dirname(__FILE__)}/../ssl_requirement/lib")
require 'mimic_ssl'