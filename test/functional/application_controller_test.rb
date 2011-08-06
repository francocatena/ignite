require 'test_helper'

class ApplicationControllerTest < ActionController::TestCase
  def setup
    @controller.send :reset_session
    @controller.send :'response=', @response
    @controller.send :'request=', @request
  end
  
  test 'require local' do
    @request.remote_addr = '127.0.0.1'
    
    assert @controller.send(:require_local)
    
    @request.remote_addr = '192.168.1.1'
    
    assert !@controller.send(:require_local)
    
    assert_redirected_to root_url
    assert_equal I18n.t(:'messages.must_be_a_local_request'),
      @controller.send(:flash)[:notice]
  end
end