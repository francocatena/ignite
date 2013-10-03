class ApplicationController < ActionController::Base
  helper_method :require_local, :local?
  
  protect_from_forgery
  
  after_filter -> { expires_now }
  
  def local?
    !!request.local?
  end
  
  def require_local
    if local?
      expires_now
    else
      redirect_to root_url, notice: t('messages.must_be_a_local_request')

      false
    end
  end
end
