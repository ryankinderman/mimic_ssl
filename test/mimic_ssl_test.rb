ENV['MIMIC_SSL'] = "true"

require File.expand_path("#{File.dirname(__FILE__)}/../lib/try_require")
try_require \
  'action_controller', 
  'ACTIONCONTROLLER_PATH',
  File.expand_path("#{File.dirname(__FILE__)}/../../../rails/actionpack/lib")
require 'action_controller/test_process'
require 'test/unit'

$LOAD_PATH.push File.expand_path("#{File.dirname(__FILE__)}/../lib")
require File.expand_path("#{File.dirname(__FILE__)}/../init")

ActionController::Base.logger = nil
ActionController::Routing::Routes.reload rescue nil

class MimicSslTest < Test::Unit::TestCase
  
  class MimicSslController < ActionController::Base
    include SslRequirement
    
    ssl_required :a
    ssl_allowed :c
    
    def a
      render :nothing => true
    end
    
    def b
      render :nothing => true
    end
    
    def c
      redirect_to :action => 'a'
    end
  end
  
  def setup
    @controller = MimicSslController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
    
  def test_redirection_to_mimicked_ssl_occurs_on_request_to_action_that_requires_ssl
    get :a
    assert_response :redirect
    assert_match /\?ssl=1/, @response.headers['Location']
  end
  
  def test_redirection_to_non_ssl_occurs_on_actual_ssl_request_to_action_that_does_not_allow_ssl
    @request.env['HTTPS'] = "on"
    get :b
    assert_response :redirect
    assert_match /^(?:(?!\?ssl=1).)+$/, @response.headers['Location']
  end
  
  def test_redirection_to_non_ssl_occurs_on_mimicked_ssl_request_to_action_that_does_not_allow_ssl
    get :b, :ssl => "1"
    assert_response :redirect
    assert_match /^(?:(?!\?ssl=1).)+$/, @response.headers['Location']
  end
  
  def test_ssl_is_mimicked_on_url_constructed_from_an_ssl_request
    get :c, :ssl => "1"
    assert_redirected_to :action => 'a'
    assert_match /\?ssl=1/, @response.headers['Location']
  end
  
end