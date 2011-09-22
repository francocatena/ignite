class ApplicationController < ActionController::Base
  helper_method :require_local
  
  protect_from_forgery
  
  before_filter lambda {
    response.headers['Cache-Control'] = 'no-cache, no-store'
  }
  
  # Rescue any exception and show it in a "nice" page
  rescue_from Exception do |exception|
    begin
      @title = t 'errors.title'
      error = "#{exception.class}: #{exception.message}\n\n"
      exception.backtrace.each { |l| error << "#{l}\n" }

      logger.error(error)

      unless response.redirect_url
        render template: 'shared/show_error', locals: {error: exception}
      end

    # En caso que la presentación misma de la excepción no salga como se espera
    rescue => ex
      error = "#{ex.class}: #{ex.message}\n\n"
      ex.backtrace.each { |l| error << "#{l}\n" }

      logger.error(error)
    end
  end
  
  def require_local
    if request.local?
      expires_now
    else
      flash.notice = t('messages.must_be_a_local_request')
      
      redirect_to root_url

      false
    end
  end
end